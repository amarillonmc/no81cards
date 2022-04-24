--星光魔术师
function c26082132.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26082132,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,26082132)
	e1:SetCondition(c26082132.spcon)
	e1:SetTarget(c26082132.sptg)
	e1:SetOperation(c26082132.spop)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,26082133)
	e2:SetTarget(c26082132.tdtg)
	e2:SetOperation(c26082132.tdop)
	c:RegisterEffect(e2)
end
function c26082132.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c26082132.thfilter(c)
	return c:IsSetCard(0x13a) and c:IsAbleToHand() 
end
function c26082132.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c26082132.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) or Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c26082132.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c26082132.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g2=Duel.SelectMatchingCard(tp,c26082132.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g2:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SendtoHand(g2,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g2)
		end
	end
end
function c26082132.tdfilter(c)
	return c:IsAbleToDeck() and c:IsType(TYPE_XYZ)
end
function c26082132.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c26082132.tdfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return e:GetHandler():IsAbleToDeck()
		and Duel.IsExistingTarget(c26082132.tdfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c26082132.tdfilter,tp,LOCATION_GRAVE,0,1,999,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c26082132.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if c:IsRelateToEffect(e) and tg:GetCount()>0 then
		tg:AddCard(c)
		Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
		local og=tg:Filter(Card.IsLocation,nil,LOCATION_EXTRA)
		local dr=math.floor(og:GetCount()/2) 
		if dr>0 then
			Duel.BreakEffect()
			Duel.Draw(tp,dr,REASON_EFFECT)
		end
	end
end
