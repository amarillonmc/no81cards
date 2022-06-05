--黄金乡的引导者
function c67077102.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67077102,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,67077102)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c67077102.target)
	e1:SetOperation(c67077102.activate)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67077102,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c67077102.setcon)
	e2:SetCountLimit(1,67077102)
	e2:SetHintTiming(TIMING_END_PHASE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c67077102.settg)
	e2:SetOperation(c67077102.setop)
	c:RegisterEffect(e2)
end
function c67077102.atkfilter(c)
	return c:IsFaceup() and c:GetAttack()>0
end
function c67077102.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and
		Duel.IsPlayerCanSpecialSummonMonster(tp,67077102,0,TYPES_NORMAL_TRAP_MONSTER,1500,800,8,RACE_ZOMBIE,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c67077102.filter(c)
	return c:IsFaceup() and c:IsCode(95440946)
end
function c67077102.thfilter(c)
	return c:IsAbleToHand() and c:IsType(TYPE_TRAP) and c:IsFaceup()
end
function c67077102.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,67077102,0,TYPES_NORMAL_TRAP_MONSTER,1500,800,8,RACE_ZOMBIE,ATTRIBUTE_LIGHT) then return end
	c:AddMonsterAttribute(TYPE_NORMAL+TYPE_TRAP)
	if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)~=0
		and Duel.IsExistingMatchingCard(c67077102.filter,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingMatchingCard(c67077102.thfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(67077102,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c67077102.thfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,3,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
		end
	end
end
function c67077102.setfilter(c)
	return c:IsSetCard(0x2142) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c67077102.setcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_END
end
function c67077102.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67077102.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c67077102.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c67077102.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SSet(tp,g)
	end
end
