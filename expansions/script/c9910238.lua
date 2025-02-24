--澄澈飞翔 有坂真白
function c9910238.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_LINK),2,99,c9910238.lcheck)
	c:EnableReviveLimit()
	--to deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9910238,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c9910238.tdtg)
	e1:SetOperation(c9910238.tdop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9910238,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9910238)
	e2:SetCondition(c9910238.spcon)
	e2:SetTarget(c9910238.sptg)
	e2:SetOperation(c9910238.spop)
	c:RegisterEffect(e2)
end
function c9910238.lcheck(g)
	return g:IsExists(Card.IsLinkMarker,1,nil,LINK_MARKER_BOTTOM_LEFT)
		and g:IsExists(Card.IsLinkMarker,1,nil,LINK_MARKER_RIGHT)
		and g:IsExists(Card.IsLinkMarker,1,nil,LINK_MARKER_TOP)
end
function c9910238.tdfilter(c)
	return c:IsRace(RACE_PSYCHO) and c:IsAbleToDeck()
end
function c9910238.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c9910238.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9910238.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c9910238.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c9910238.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsRace(RACE_PSYCHO) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end
function c9910238.spcon(e,tp,eg,ep,ev,re,r,rp)
	local race=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_RACE)
	return re:IsActiveType(TYPE_MONSTER) and race&RACE_PSYCHO>0 and re:GetHandler()~=e:GetHandler()
end
function c9910238.filter(c,e,tp,ft)
	return c:IsSetCard(0x6956) and c:IsType(TYPE_MONSTER)
		and (c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function c9910238.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910238.filter,tp,LOCATION_DECK,0,1,nil,e,tp,ft) end
end
function c9910238.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9910238.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp,ft)
	local tc=g:GetFirst()
	if tc then
		if ft>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and (not tc:IsAbleToHand() or Duel.SelectOption(tp,1190,1152)==1) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end
