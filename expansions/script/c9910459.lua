--欢欣激奏的韶光
function c9910459.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c9910459.target)
	e1:SetOperation(c9910459.activate)
	c:RegisterEffect(e1)
end
function c9910459.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_GRAVE and chkc:IsAbleToDeck() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler(),0x1950,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,5,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),PLAYER_ALL,LOCATION_GRAVE)
end
function c9910459.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.SendtoDeck(g1,nil,2,REASON_EFFECT)
	local ct=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_DECK)
	local g2=Duel.GetMatchingGroup(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e),0x1950,1)
	if ct>0 then
		for i=1,ct do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
			local sg2=g2:Select(tp,1,1,nil)
			sg2:GetFirst():AddCounter(0x1950,1)
		end
	end
	if Duel.GetCounter(tp,1,1,0x1950)<5 then return end
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		c:CancelToGrave()
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(9910459,0))
		e1:SetCategory(CATEGORY_TOHAND+CATEGORY_COUNTER)
		e1:SetType(EFFECT_TYPE_QUICK_O)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetRange(LOCATION_SZONE)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
		e1:SetCountLimit(1)
		e1:SetCost(c9910459.thcost)
		e1:SetTarget(c9910459.thtg)
		e1:SetOperation(c9910459.thop)
		c:RegisterEffect(e1)
	end
end
function c9910459.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) end
	Duel.PayLPCost(tp,2000)
end
function c9910459.thfilter(c)
	return c:GetCounter(0x1950)>0 and c:IsAbleToHand()
end
function c9910459.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910459.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_ONFIELD)
end
function c9910459.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c9910459.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	local tc=g:GetFirst()
	if not tc then return end
	local count=tc:GetCounter(0x1950)
	if Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and tc:IsControler(tp) and tc:IsLocation(LOCATION_HAND)
		and c:IsRelateToEffect(e) and Duel.SelectYesNo(tp,aux.Stringid(9910459,1)) then
		Duel.BreakEffect()
		c:AddCounter(0x1950,count)
	end
end
