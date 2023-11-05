--OOO驱动器
function c32100014.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)   
	e1:SetCountLimit(1,32100014) 
	e1:SetCost(c32100014.cost)
	e1:SetTarget(c32100014.target)
	e1:SetOperation(c32100014.activate)
	c:RegisterEffect(e1) 
	--to deck and to hand 
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,32100014)  
	e1:SetTarget(c32100014.tdhtg)
	e1:SetOperation(c32100014.tdhop)
	c:RegisterEffect(e1)
end
function c32100014.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,2,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,2,2,REASON_COST+REASON_DISCARD,e:GetHandler())
end 
function c32100014.filter(c)
	return c.SetCard_HR_Corecoin and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c32100014.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c32100014.filter,tp,LOCATION_DECK,0,3,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c32100014.activate(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c32100014.filter,tp,LOCATION_DECK,0,3,3,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end 
function c32100014.tdhtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(function(c) return c.SetCard_HR_Corecoin and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck() end,tp,LOCATION_GRAVE,0,3,nil) and e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,3,tp,LOCATION_GRAVE) 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0) 
end
function c32100014.tdhop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if Duel.IsExistingMatchingCard(function(c) return c.SetCard_HR_Corecoin and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck() end,tp,LOCATION_GRAVE,0,3,nil) then 
		local sg=Duel.SelectMatchingCard(tp,function(c) return c.SetCard_HR_Corecoin and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck() end,tp,LOCATION_GRAVE,0,3,3,nil) 
		if Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) then 
			Duel.SendtoHand(c,nil,REASON_EFFECT) 
		end 
	end 
end 





