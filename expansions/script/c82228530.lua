function c82228530.initial_effect(c)  
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(82228530,0))  
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c82228530.condition)  
	e1:SetTarget(c82228530.target)  
	e1:SetOperation(c82228530.activate)  
	c:RegisterEffect(e1)
end
function c82228530.cfilter(c)  
	return c:GetAttack()==1350 
end  
function c82228530.condition(e,tp,eg,ep,ev,re,r,rp)  
	if not Duel.IsExistingMatchingCard(c82228530.cfilter,tp,LOCATION_GRAVE,0,1,nil) then return false end  
	if not Duel.IsChainNegatable(ev) then return false end  
	return true
end  
function c82228530.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)  
	if re:GetHandler():IsAbleToRemove() and re:GetHandler():IsRelateToEffect(re) then  
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)  
	end  
end  
function c82228530.activate(e,tp,eg,ep,ev,re,r,rp)  
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then  
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)  
	end  
end  