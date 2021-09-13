--生灵探秘
function c9910887.initial_effect(c)
	aux.AddCodeList(c,9910871)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9910887+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9910887.target)
	e1:SetOperation(c9910887.activate)
	c:RegisterEffect(e1)
end
function c9910887.filter1(c)
	return c:IsCode(9910871) and c:IsAbleToHand()
end
function c9910887.filter2(c)
	return aux.IsCodeListed(c,9910871) and c:IsLevel(4) and c:IsAbleToHand()
end
function c9910887.tdfilter(c)
	return not c:IsPublic() and c:IsAbleToDeck()
end
function c9910887.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910887.filter1,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(c9910887.filter2,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(c9910887.tdfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c9910887.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c9910887.tdfilter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()==0 then return end
	Duel.ConfirmCards(1-tp,g)
	local g1=Duel.GetMatchingGroup(c9910887.filter1,tp,LOCATION_DECK,0,nil)
	local g2=Duel.GetMatchingGroup(c9910887.filter2,tp,LOCATION_DECK,0,nil)
	if g1:GetCount()>0 and g2:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg2=g2:Select(tp,1,1,nil)
		sg1:Merge(sg2)
		Duel.SendtoHand(sg1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg1)
		Duel.BreakEffect()
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	else
		Duel.ShuffleHand(tp)
	end
end
