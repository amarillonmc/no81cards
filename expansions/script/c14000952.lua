--刃心刻神仪
local m=14000952
local cm=_G["c"..m]
cm.named_with_Sealoritual=1
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_HANDES+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.tgtg)
	e1:SetOperation(cm.tgop)
	c:RegisterEffect(e1)
end
function cm.Seal(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Sealoritual
end
function cm.tgfilter(c)
	return cm.Seal(c) and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function cm.nmfilter(c)
	return c:IsCode(14000951)
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 and Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			if Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
				if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.nmfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsPlayerCanSpecialSummonMonster(tp,14000951,0,0x40a1,2000,0,4,RACE_WYRM,ATTRIBUTE_DARK,POS_FACEUP,tp,SUMMON_TYPE_RITUAL) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
					local token=Duel.CreateToken(tp,14000951)
					Duel.SpecialSummon(token,SUMMON_TYPE_RITUAL,tp,tp,false,false,POS_FACEUP)
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_CHANGE_TYPE)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetValue(TYPE_RITUAL+TYPE_TOKEN+TYPE_MONSTER)
					e1:SetReset(RESET_EVENT+0x1fe0000)
					token:RegisterEffect(e1,true)
					--[[local e2=Effect.CreateEffect(e:GetHandler())
					e2:SetType(EFFECT_TYPE_SINGLE)
					e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
					e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e2:SetReset(RESET_EVENT+RESETS_REDIRECT)
					e2:SetValue(-1)
					token:RegisterEffect(e2,true)
					token:CopyEffect(14000951,RESET_EVENT+RESETS_STANDARD,1)]]
					token:RegisterFlagEffect(0,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1))
				end
			end
		end
	end
end