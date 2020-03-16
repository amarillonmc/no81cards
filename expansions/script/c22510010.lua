--机械回收
function c22510010.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(0,EFFECT_FLAG2_COF)
	e1:SetCondition(c22510010.condition)
	e1:SetTarget(c22510010.target)
	e1:SetOperation(c22510010.activate)
	c:RegisterEffect(e1)
end
function c22510010.condition(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetTurnPlayer()==tp or Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==4) and Duel.GetCurrentChain()==0 and e:GetHandler():IsLocation(LOCATION_SZONE)
end
function c22510010.filter(c)
	return c:IsSetCard(0xec0) and c:IsAbleToDeck()
end
function c22510010.filter2(c)
	return c:IsSetCard(0xec0) and c:IsAbleToHand()
end
function c22510010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22510010.filter,tp,LOCATION_GRAVE,0,4,nil) and Duel.IsExistingMatchingCard(c22510010.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,4,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c22510010.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tg=Duel.SelectMatchingCard(tp,c22510010.filter,tp,LOCATION_GRAVE,0,4,4,nil)
	if tg and Duel.SendtoDeck(tg,nil,2,REASON_EFFECT) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c22510010.filter2,tp,LOCATION_DECK,0,1,1,nil)
		if not g then return end
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
