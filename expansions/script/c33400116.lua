--刻刻帝 灵力回收
function c33400116.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,33400116+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c33400116.target)
	e1:SetOperation(c33400116.activate)
	c:RegisterEffect(e1)
end
function c33400116.filter(c)
	return (c:IsSetCard(0x341) or c:IsSetCard(0x340)) and c:IsFaceup() and c:IsAbleToDeck()
end
function c33400116.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED+LOCATION_GRAVE) and chkc:IsControler(tp) and c33400116.filter(chkc) end
	if chk==0 then return   Duel.IsExistingTarget(c33400116.filter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c33400116.filter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c33400116.thfilter(c)
	return (c:IsSetCard(0x3340) or c:IsSetCard(0x3341)) and c:IsAbleToHand()
end
function c33400116.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg5=tg:Filter(Card.IsRelateToEffect,nil,e)
	Duel.SendtoDeck(tg5,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
   if Duel.IsExistingMatchingCard(c33400116.thfilter,tp,LOCATION_DECK,0,1,nil) then
		if Duel.SelectYesNo(tp,aux.Stringid(33400116,0)) then
		 local tg1=Duel.GetMatchingGroup(c33400116.thfilter,tp,LOCATION_DECK,0,nil)
		 local tc1=tg1:Select(tp,1,1,nil)
		 Duel.SendtoHand(tc1,nil,REASON_EFFECT)
		 Duel.ConfirmCards(1-tp,tc1)
		end
   end
 Duel.RegisterFlagEffect(tp,33400101,RESET_EVENT+RESET_PHASE+PHASE_END,0,0)
end
