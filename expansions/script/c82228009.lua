function c82228009.initial_effect(c)  
	--Activate(effect)  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_CHAINING)  
	e1:SetCondition(c82228009.condition)  
	e1:SetCost(c82228009.cost)  
	e1:SetCountLimit(1,82228009) 
	e1:SetTarget(c82228009.target)  
	e1:SetOperation(c82228009.activate)  
	c:RegisterEffect(e1)  
	--to deck  
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_TODECK)  
	e3:SetType(EFFECT_TYPE_QUICK_O)  
	e3:SetRange(LOCATION_GRAVE) 
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,82238009)  
	e3:SetCost(c82228009.cost2)  
	e3:SetTarget(c82228009.tg2)  
	e3:SetOperation(c82228009.op2)  
	c:RegisterEffect(e3)  
end  
function c82228009.cfilter(c)  
	return c:IsSetCard(0x290) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()  
end  
function c82228009.condition(e,tp,eg,ep,ev,re,r,rp)  
	return rp==1-tp and Duel.IsChainNegatable(ev)  
end  
function c82228009.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c82228009.cfilter,tp,LOCATION_GRAVE,0,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)  
	local g=Duel.SelectMatchingCard(tp,c82228009.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)  
	Duel.Remove(g,POS_FACEUP,REASON_COST)  
end  
function c82228009.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)  
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then  
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)  
	end  
end  
function c82228009.activate(e,tp,eg,ep,ev,re,r,rp)  
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then  
		Duel.Destroy(eg,REASON_EFFECT)  
	end  
end  
function c82228009.cfilter2(c,e)  
	return c:IsSetCard(0x290) and c:IsAbleToRemoveAsCost()
end  
function c82228009.cost2(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c82228009.cfilter2,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)  
	local g=Duel.SelectMatchingCard(tp,c82228009.cfilter2,tp,LOCATION_GRAVE,0,1,1,nil)  
	Duel.Remove(g,POS_FACEUP,REASON_COST)  
end  
function c82228009.tg2(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()  
	if chk==0 then return c:IsAbleToDeck() end  
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)  
end  
function c82228009.op2(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if c:IsRelateToEffect(e) then  
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT)  
	end  
end