--神数的神选士
function c19198107.initial_effect(c)
 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,19198107+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c19198107.cost)
	e1:SetTarget(c19198107.target)
	e1:SetOperation(c19198107.activate)
	c:RegisterEffect(e1)
		--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c19198107.handcon)
	c:RegisterEffect(e2)
end
function c19198107.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c19198107.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,19198107,0,0xc4,0,0,1,RACE_WYRM,ATTRIBUTE_LIGHT) end
	e:SetLabel(0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c19198107.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,19198107,0,0xc4,0,0,1,RACE_WYRM,ATTRIBUTE_LIGHT) then
		c:AddMonsterAttribute(TYPE_NORMAL+TYPE_TUNER)
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP_DEFENSE)
	end
end
function c19198107.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xc4)
end
function c19198107.handcon(e)
	return Duel.IsExistingMatchingCard(c19198107.filter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,2,nil)
end