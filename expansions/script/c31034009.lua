--Speed Recalibrate
function c31034009.initial_effect(c)
	aux.AddCodeList(c, 31034011)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c31034009.target)
	e1:SetOperation(c31034009.operation)
	c:RegisterEffect(e1)
end

function c31034009.addfilter(c)
	return (c:IsCode(31034011) or c:IsCode(31034015) or c:IsCode(31034017)) and c:IsAbleToHand()
end

function c31034009.syfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsAbleToExtra()
end

function c31034009.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c31034009.syfilter(chkc) end
	if chk == 0 then return Duel.IsExistingTarget(c31034009.syfilter, tp, LOCATION_MZONE, 0, 1, nil, tp) and 
			Duel.IsExistingMatchingCard(c31034009.addfilter, tp, LOCATION_DECK, 0, 1, nil) end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c31034009.syfilter, tp, LOCATION_MZONE, 0, 1, 1, nil)
	Duel.SetOperationInfo(0, CATEGORY_TOEXTRA, g, 1, 0, 0)
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
end

function c31034009.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT) ~= 0 and tc:IsLocation(LOCATION_EXTRA) then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp, c31034009.addfilter, tp, LOCATION_DECK, 0, 1, 1, nil)
		if g:GetCount() > 0 then
			Duel.SendtoHand(g, nil, REASON_EFFECT)
			Duel.ConfirmCards(1-tp, g)
			if tc:IsAttribute(ATTRIBUTE_WIND) then
				Duel.Draw(tp, 1, REASON_EFFECT)
			end
		end
	end
end