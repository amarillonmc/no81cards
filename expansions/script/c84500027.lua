function c84500027.initial_effect(c)
	aux.AddRitualProcGreater(c,c84500027.ritual_filter)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c84500027.tdtg)
	e2:SetOperation(c84500027.tdop)
	c:RegisterEffect(e2)
end
function c84500027.ritual_filter(c)
	return c:IsSetCard(0xf4) and bit.band(c:GetType(),0x81)==0x81
end
function c84500027.thfilter(c)
	return c:IsCode(84500026) and c:IsAbleToDeck()
end
function c84500027.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c84500027.thfilter(chkc) end
	if chk==0 then return e:GetHandler():IsAbleToDeck() and Duel.IsExistingTarget(c84500027.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c84500027.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,1,tp,LOCATION_DECK)
end
function c84500027.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and Duel.SendtoDeck(Group.FromCards(c,tc),nil,nil,REASON_EFFECT)==2 then
		Duel.ShuffleDeck(tp)
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end