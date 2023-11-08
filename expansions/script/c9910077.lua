--随风流雪之月神
function c9910077.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_FAIRY),4,2)
	c:EnableReviveLimit()
	--xyzmat to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9910077)
	e1:SetCost(c9910077.thcost)
	e1:SetTarget(c9910077.thtg)
	e1:SetOperation(c9910077.thop)
	c:RegisterEffect(e1)
end
function c9910077.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) end
	Duel.PayLPCost(tp,2000)
end
function c9910077.thfilter(c,tp)
	return c:IsRace(RACE_FAIRY) and c:IsAbleToHand() and c:GetOwner()==tp
end
function c9910077.xfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:GetOverlayGroup():IsExists(c9910077.thfilter,2,nil,tp)
end
function c9910077.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c9910077.xfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c9910077.xfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c9910077.xfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_OVERLAY)
end
function c9910077.spfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9910077.tdfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToDeck()
end
function c9910077.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local mg=tc:GetOverlayGroup():Filter(c9910077.thfilter,nil,tp)
	if tc:IsRelateToEffect(e) and #mg>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=mg:Select(tp,2,2,nil)
		if Duel.SendtoHand(sg,nil,REASON_EFFECT)==0 then return end
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleHand(tp)
		local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_HAND)
		local g1=og:Filter(c9910077.spfilter,nil,e,tp)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and #g1>0 and Duel.SelectYesNo(tp,aux.Stringid(9910077,0)) then
			Duel.BreakEffect()
			if #g1>1 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				g1=g1:Select(tp,1,1,nil)
				Duel.HintSelection(g1)
			end
			Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
			og:Sub(g1)
		end
		local g2=og:Filter(c9910077.tdfilter,nil)
		if #g2>0 and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(9910077,1)) then
			Duel.BreakEffect()
			if #g2>1 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
				g2=g2:Select(tp,1,1,nil)
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local tg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,1,nil)
			if #tg>0 then
				g2:Merge(tg)
				Duel.HintSelection(g2)
				Duel.SendtoDeck(g2,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
			end
		end
	end
end
