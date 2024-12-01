--方舟骑士共赴黎明
function c29012513.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,29012513+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c29012513.target)
	e1:SetOperation(c29012513.activate)
	c:RegisterEffect(e1)
	--Draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29012513,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c29012513.drtg)
	e2:SetOperation(c29012513.drop)
	c:RegisterEffect(e2)
end
function c29012513.tdfilter(c,e,tp)
	return c:IsSetCard(0x87af) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToDeck()
end
function c29012513.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c29012513.tdfilter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2)
		and Duel.IsExistingTarget(c29012513.tdfilter,tp,LOCATION_GRAVE,0,5,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c29012513.tdfilter,tp,LOCATION_GRAVE,0,5,5,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c29012513.drop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #tg==0 then return end
	Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct>0 then
		Duel.BreakEffect()
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end
function c29012513.filter(c,ft,e,tp)
	return c:IsSetCard(0x87af) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsType(TYPE_MONSTER) and (c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function c29012513.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		return Duel.IsExistingMatchingCard(c29012513.filter,tp,LOCATION_GRAVE,0,1,nil,ft,e,tp)
	end
end
function c29012513.spfilter(c,e,tp,tid)
	return c:GetTurnID()==tid and bit.band(c:GetReason(),REASON_DESTROY)~=0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c29012513.activate(e,tp,eg,ep,ev,re,r,rp)
	local tid=Duel.GetTurnCount()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local res=0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c29012513.filter,tp,LOCATION_GRAVE,0,1,1,nil,ft,e,tp)
	if g:GetCount()>0 then
		local th=g:GetFirst():IsAbleToHand()
		local sp=ft>0 and g:GetFirst():IsCanBeSpecialSummoned(e,0,tp,false,false)
		local op=0
		if th and sp then op=Duel.SelectOption(tp,1190,1152)
		elseif th then op=0
		else op=1 end
		if op==0 then
			res=Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		else
			res=Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
			if res>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c29012513.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp,tid) and Duel.SelectYesNo(tp,aux.Stringid(29012513,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g2=Duel.SelectMatchingCard(tp,c29012513.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp,tid)
			local tc=g2:GetFirst()
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			end
			Duel.SpecialSummonComplete()
	end
end