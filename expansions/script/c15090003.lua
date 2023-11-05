local m=15090003
local cm=_G["c"..m]
cm.name="花札卫-门-"
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,cm.mfilter,1,1)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(15090003)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e0)
	--hand Link
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e1:SetRange(LOCATION_HAND)
	e1:SetValue(cm.matval)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetTarget(cm.mattg)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(cm.stg)
	e3:SetOperation(cm.sop)
	c:RegisterEffect(e3)
	if not cm.doorCheck then
		cm.doorCheck=true
		_DoorDraw=Duel.Draw
		function Duel.Draw(p,ct,reason)
			if Duel.IsPlayerAffectedByEffect(p,15090002) and reason&REASON_EFFECT==REASON_EFFECT then
				local g=Duel.GetMatchingGroup((function(c) return c:IsSetCard(0xe6) and (c:IsAbleToDeck() or c:IsLocation(LOCATION_DECK)) end),p,LOCATION_HAND+LOCATION_DECK,0,nil)
				if #g>0 and Duel.SelectYesNo(p,aux.Stringid(m,1)) then
					Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
					local tc=g:Select(p,1,1,nil):GetFirst()
					if tc:IsLocation(LOCATION_DECK) then
						Duel.ShuffleDeck(p)
						Duel.MoveSequence(tc,SEQ_DECKTOP)
						Duel.ConfirmDecktop(p,1)
					else
						Duel.ConfirmCards(1-p,tc)
						Duel.SendtoDeck(tc,nil,SEQ_DECKTOP,REASON_EFFECT)
					end
				end
			end
			return _DoorDraw(p,ct,reason)
		end
	end
end
function cm.mfilter(c)
	return c:IsLinkSetCard(0xe6) and not c:IsLinkCode(15090003)
end
function cm.mattg(e,c)
	return c:GetOriginalType()&TYPE_MONSTER==TYPE_MONSTER and c:IsLinkSetCard(0xe6)
end
function cm.exmfilter(c,sc)
	return c:IsLocation(LOCATION_HAND) and c==sc
end
function cm.matval(e,lc,mg,c,tp)
	if not lc:IsHasEffect(15090003) then return false,nil end
	return true,true
end
function cm.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function cm.sop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=1 or not c:IsRelateToEffect(e) then return end
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
	c:RegisterEffect(e1)
	--change effect type
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(15090002)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(1,0)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)
end