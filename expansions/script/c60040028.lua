--原初之一
local cm,m,o=GetID()
function cm.initial_effect(c)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(cm.con)
	c:RegisterEffect(e2)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,m-2)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if e:GetHandler():IsStatus(STATUS_ACT_FROM_HAND) then
		e:SetLabel(1)
	else
		e:SetLabel(2)
	end
	if e:GetLabel()==2 then
		if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
			and Duel.IsPlayerCanSpecialSummonMonster(tp,60040024,0,TYPES_TOKEN_MONSTER,100,100,1,RACE_MACHINE,ATTRIBUTE_DARK,POS_FACEUP_DEFENSE) end
		Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
	elseif e:GetLabel()==1 then
		if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,60040026) end
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_ACT_FROM_HAND) then
		e:SetLabel(1)
	else
		e:SetLabel(2)
	end
	if e:GetLabel()==2 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 or not Duel.IsPlayerCanSpecialSummonMonster(tp,m+1,0,TYPES_TOKEN_MONSTER,100,100,1,RACE_MACHINE,ATTRIBUTE_DARK,POS_FACEUP_DEFENSE) or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
		for i=1,2 do
			local token=Duel.CreateToken(tp,60040024)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		end
		Duel.SpecialSummonComplete()
	elseif e:GetLabel()==1 then
		local tc=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_MZONE,0,nil,60040026):Select(tp,1,1,nil)
		--if tc:IsRelateToEffect(e) then
			local e11=Effect.CreateEffect(e:GetHandler())
			e11:SetType(EFFECT_TYPE_SINGLE)
			e11:SetCode(EFFECT_UPDATE_ATTACK)
			e11:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e11:SetValue(3000)
			tc:RegisterEffect(e11)
		--end
	end
end