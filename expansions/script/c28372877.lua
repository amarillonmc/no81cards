--L'Antica秘密基地
function c28372877.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetOperation(c28372877.activate)
	c:RegisterEffect(e0)
	--to deck
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TODECK)
	e5:SetType(EFFECT_TYPE_IGNITION)
	--e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_FZONE)
	e5:SetTarget(c28372877.tdtg)
	e5:SetOperation(c28372877.tdop)
	c:RegisterEffect(e5)
end
function c28372877.thfilter(c)
	return c:IsSetCard(0x285) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c28372877.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,0x285):Filter(Card.IsFaceupEx,nil)
	local g2=Duel.GetMatchingGroup(c28372877.thfilter,tp,LOCATION_DECK,0,nil)
	if #g1>0 and #g2>0 and Duel.SelectYesNo(tp,aux.Stringid(28372877,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=g1:Select(tp,1,1,nil)
		Duel.HintSelection(dg)
		Duel.Destroy(dg,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g2:Select(tp,#dg,#dg,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c28372877.tdfilter(c,ct)
	return (c:IsReason(REASON_DESTROY) and c:GetTurnID()==Duel.GetTurnCount() and c:IsType(TYPE_MONSTER) and ct~=2 or ct~=1 and c:IsSetCard(0x285) and c:IsFaceupEx()) and c:IsAbleToDeck()
end
function c28372877.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c28372877.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,0)
	if chk==0 then return aux.gfcheck(c28372877.tdfilter,1,2) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c28372877.gcheck(g)
	return g:FilterCount(c28372877.tdfilter,nil,1)>=#g/2 and g:FilterCount(c28372877.tdfilter,nil,2)>=#g/2 and #g%2==0--g:CheckSubGroup(c28372877.ctcheck,#g/2,#g/2,g)
end
function c28372877.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c28372877.tdfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,0)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:SelectSubGroup(tp,c28372877.gcheck,false,2,#g)
	if sg:GetCount()==0 then return end
	Duel.HintSelection(sg)
	Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end
