--梦之始
function c1184062.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c1184062.tg1)
	e1:SetOperation(c1184062.op1)
	c:RegisterEffect(e1)
--
end
--
function c1184062.tfilter1(c)
	return c:IsSetCard(0x3e12) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c1184062.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_DECK,0,1,e:GetHandler())
		and Duel.GetMatchingGroup(c1184062.tfilter1,tp,LOCATION_DECK,0,nil):GetClassCount(Card.GetCode)>1 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c1184062.ofilter1(sg)
	return sg:GetClassCount(Card.GetCode)==sg:GetCount()
end
function c1184062.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
	if sg:GetCount()>0 and Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)>0 then
		local dg=Duel.GetMatchingGroup(c1184062.tfilter1,tp,LOCATION_DECK,0,nil)
		if dg:GetClassCount(Card.GetCode)<2 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local lg=dg:SelectSubGroup(tp,c1184062.ofilter1,false,2,2)
		Duel.SendtoHand(lg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,lg)
	end
end
--
