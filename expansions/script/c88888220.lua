--CAN:D 错乱激发现象！
function c88888220.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(88888220,0))
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,88888220+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c88888220.condition)
	e1:SetTarget(c88888220.target)
	e1:SetOperation(c88888220.activate1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(88888220,1))
	e2:SetCost(c88888220.cost)
	e2:SetOperation(c88888220.activate2)
	c:RegisterEffect(e2)
end
function c88888220.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x8908) and c:IsType(TYPE_XYZ)
end
function c88888220.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c88888220.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsChainNegatable(ev) and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function c88888220.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c88888220.activate1(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
function c88888220.costfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) and c:IsAbleToGraveAsCost()
end
function c88888220.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88888220.costfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c88888220.costfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c88888220.activate2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEDOWN,REASON_EFFECT)
	end
end