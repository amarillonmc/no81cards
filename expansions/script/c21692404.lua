--灵光命运归途
function c21692404.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	c:RegisterEffect(e1) 
	--to hand 
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_SZONE) 
	e1:SetCountLimit(1) 
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2 end)
	e1:SetCost(c21692404.thcost) 
	e1:SetTarget(c21692404.thtg) 
	e1:SetOperation(c21692404.thop) 
	c:RegisterEffect(e1) 
	--to deck and draw  
	local e2=Effect.CreateEffect(c)  
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_PHASE+PHASE_END) 
	e2:SetRange(LOCATION_SZONE) 
	e2:SetCountLimit(1,21692404)  
	e2:SetTarget(c21692404.tddtg) 
	e2:SetOperation(c21692404.tddop) 
	c:RegisterEffect(e2) 
end
c21692404.SetCard_ZW_ShLight=true 
function c21692404.ctfil(c) 
	return c:IsAbleToHandAsCost() and c:IsSetCard(0x555) 
end 
function c21692404.thcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c21692404.ctfil,tp,LOCATION_MZONE,0,1,nil) end 
	local g=Duel.SelectMatchingCard(tp,c21692404.ctfil,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoHand(g,nil,REASON_COST)
end 
function c21692404.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) end 
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,1,nil) 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0) 
end 
function c21692404.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) then 
		Duel.SendtoHand(tc,nil,REASON_EFFECT) 
	end 
end 
function c21692404.tddtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsAbleToDeck() and c:IsSetCard(0x555) end,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) and Duel.IsPlayerCanDraw(tp,1) end 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,3,tp,LOCATION_GRAVE+LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1) 
end 
function c21692404.tddop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsAbleToDeck() and c:IsSetCard(0x555) end,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,3,nil) then 
		local sg=Duel.SelectMatchingCard(tp,function(c) return c:IsFaceup() and c:IsAbleToDeck() and c:IsSetCard(0x555) end,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,3,nil) 
		if Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)~=0 then 
			Duel.BreakEffect() 
			Duel.Draw(tp,1,REASON_EFFECT) 
		end 
	end  
end 
