--诡雷战队 侦察兵
--21.04.22
local cm,m=GetID()
function cm.initial_effect(c)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(function() return not pnfl_adjusting end)
	e1:SetOperation(cm.adjustop)
	c:RegisterEffect(e1)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.con)
	e2:SetTarget(cm.eqtg)
	e2:SetOperation(cm.eqop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(cm.con2)
	c:RegisterEffect(e3)
end
function cm.eqfilter(c)
	return c:GetFlagEffect(m)~=0
end
function cm.eqlimit(e,c)
	return e:GetOwner()==c
end
function cm.eqlimit2(e,c)
	return e:GetLabelObject()==c
end
function cm.equipfd(c,tp,tc)
	if tc:IsPosition(POS_FACEUP) then Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEDOWN,false) end
	if not Duel.Equip(tp,tc,c,false) then return false end
	--Add Equip limit
	tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(cm.eqlimit)
	tc:RegisterEffect(e1)
	return true
end
function cm.equipfd2(c,tp,tc)
	if tc:IsPosition(POS_FACEUP) then Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEDOWN,false) end
	if not Duel.Equip(tp,tc,c,false) then return false end
	return true
end
function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
	if pnfl_adjusting then return end
	local phase=Duel.GetCurrentPhase()
	local c=e:GetHandler()
	local flag=c:GetFlagEffectLabel(11451552)
	if not ((phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL or c:IsStatus(STATUS_BATTLE_DESTROYED)) and Duel.IsPlayerCanSSet(tp) and c:IsLocation(LOCATION_MZONE) and not c:GetEquipGroup():IsExists(cm.eqfilter,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.GetMatchingGroupCount(nil,tp,LOCATION_DECK,0,nil)>0 and (not flag or flag>2) then
		if flag then
			flag=flag-1
			c:ResetFlagEffect(11451552)
			c:RegisterFlagEffect(11451552,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,flag,aux.Stringid(11451552,flag))
		else
			c:RegisterFlagEffect(11451552,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,3,aux.Stringid(11451552,3))
		end
		Duel.Hint(HINT_CARD,0,m)
		--Duel.HintSelection(Group.FromCards(c))
		local tc=Duel.GetMatchingGroup(nil,tp,LOCATION_DECK,0,nil):GetMaxGroup(Card.GetSequence):GetFirst()
		Duel.DisableShuffleCheck()
		pnfl_adjusting=true
		if tc:IsForbidden() then
			Duel.DiscardDeck(tp,1,REASON_RULE)
			pnfl_adjusting=false
			cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
		elseif cm.equipfd(c,tp,tc) then
			Duel.RaiseEvent(tc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
			pnfl_adjusting=false
			Duel.Readjust()
		end
		pnfl_adjusting=false
	end
	pnfl_adjusting=false
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,11451556)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,11451556)
end
function cm.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local qg=Duel.GetMatchingGroup(function(c) return c:IsFaceup() and c:IsType(TYPE_EFFECT) end,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3 and #qg>0 end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK)
end
function cm.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SET_SUMMON_COUNT_LIMIT)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetValue(2)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local qg=Duel.GetMatchingGroup(function(c) return c:IsFaceup() and c:IsType(TYPE_EFFECT) end,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<3 or Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or #qg==0 then return end
	local g=Duel.GetDecktopGroup(tp,3)
	--Duel.ConfirmCards(tp,g)
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_EQUIP)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tg=qg:Select(tp,1,1,nil)
	Duel.HintSelection(tg)
	if tc:IsForbidden() then
		Duel.SendtoGrave(tc,REASON_RULE)
	elseif cm.equipfd2(tg:GetFirst(),tp,tc) then
		Duel.RaiseEvent(tc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetLabelObject(tg:GetFirst())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(cm.eqlimit2)
		tc:RegisterEffect(e1)
	end
	Duel.ShuffleDeck(tp)
end