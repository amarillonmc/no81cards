--放课后梦想盛开！
function c28330319.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c28330319.target)
	e1:SetOperation(c28330319.activate)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c28330319.tdtg)
	e2:SetOperation(c28330319.tdop)
	c:RegisterEffect(e2)
end
function c28330319.chkfilter(c)
	return c:IsSetCard(0x286) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:IsAbleToGrave()
end
function c28330319.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local dg=Duel.GetMatchingGroup(c28330319.chkfilter,tp,LOCATION_DECK,0,nil)
		return dg:GetClassCount(Card.GetAttribute)>=3
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c28330319.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c28330319.chkfilter,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetAttribute)<3 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local cg=g:SelectSubGroup(tp,aux.dabcheck,false,3,3)
	if #cg==0 then return end
	Duel.ConfirmCards(1-tp,cg)
	local sg=cg:RandomSelect(1-tp,2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=sg:Select(tp,1,1,nil)
	Duel.SendtoHand(tg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tg)
	sg:Sub(tg)
	Duel.SendtoGrave(sg,REASON_EFFECT)
end
function c28330319.tdfilter(c)
	return c:IsSetCard(0x286) and c:IsAbleToDeck() and c:IsAbleToHand() and c:IsFaceupEx()
end
function c28330319.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	local ct=g:GetClassCount(Card.GetAttribute)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(0x30) and c28330319.tdfilter(chkc) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(c28330319.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,c) and ct>0 and c:IsAbleToDeck() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tg=Duel.SelectTarget(tp,c28330319.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,ct,c)
	tg:AddCard(c)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,tg,tg:GetCount(),0,0)
end
function c28330319.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=g:FilterSelect(tp,Card.IsAbleToHand,1,1,nil):GetFirst()
	if not tc then return end
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc)
	if not (tc:IsLocation(LOCATION_HAND) and e:GetHandler():IsRelateToEffect(e)) then return end
	g:AddCard(e:GetHandler())
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end
