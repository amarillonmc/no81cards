--人理之诗 刹那无影剑
function c22021340.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,22021340+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c22021340.condition)
	e1:SetCost(c22021340.cost)
	e1:SetTarget(c22021340.target)
	e1:SetOperation(c22021340.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c22021340.handcon)
	c:RegisterEffect(e2)
end
function c22021340.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c22021340.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1800) end
	Duel.PayLPCost(tp,1800)
end
function c22021340.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c22021340.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c22021340.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xff9) and c:IsType(TYPE_LINK)
end
function c22021340.handcon(e)
	return Duel.IsExistingMatchingCard(c22021340.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end