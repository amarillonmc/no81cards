--浮于天地之灯
function c60001199.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60001199,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,60001199)
	e1:SetCondition(c60001199.condition)
	e1:SetTarget(c60001199.target)
	e1:SetOperation(c60001199.activate)
	c:RegisterEffect(e1)   
	--to deck and draw 
	local e2=Effect.CreateEffect(c)  
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_RELEASE)  
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetCountLimit(1,10001199)
	e2:SetTarget(c60001199.tddtg) 
	e2:SetOperation(c60001199.tddop) 
	c:RegisterEffect(e2)  
end
function c60001199.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6a5)  
end
function c60001199.condition(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c60001199.cfilter,tp,LOCATION_MZONE,0,2,nil) then return false end
	if not Duel.IsChainNegatable(ev) then return false end
	return rp==1-tp 
end
function c60001199.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c60001199.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c60001199.tddtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_GRAVE,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE) 
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1) 
end 
function c60001199.tddop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_GRAVE,0,nil) 
	if g:GetCount()<=0 then return end 
	local sg=g:Select(tp,1,1,nil) 
	if Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)~=0 and Duel.IsPlayerCanDraw(tp,1) then 
	Duel.Draw(tp,1,REASON_EFFECT) 
	end 
end 






