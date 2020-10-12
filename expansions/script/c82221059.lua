function c82221059.initial_effect(c)  
	--Activate  
	local e1=Effect.CreateEffect(c)   
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_CHAINING)   
	e1:SetCondition(c82221059.condition)  
	e1:SetTarget(c82221059.target)  
	e1:SetOperation(c82221059.activate)  
	c:RegisterEffect(e1)
end  
function c82221059.cfilter(c)  
	return c:IsFaceup() and c:IsSetCard(0x99)
end  
function c82221059.condition(e,tp,eg,ep,ev,re,r,rp)  
	if not Duel.IsExistingMatchingCard(c82221059.cfilter,tp,LOCATION_ONFIELD,0,1,nil) then return false end  
	if not Duel.IsChainNegatable(ev) then return false end  
	return re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)  
end  
function c82221059.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)  
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then  
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)  
	end  
end  
function c82221059.activate(e,tp,eg,ep,ev,re,r,rp)  
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then  
		Duel.Destroy(eg,REASON_EFFECT)  
	end  
end  