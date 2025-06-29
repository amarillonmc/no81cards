--虹彩偶像的合演
function c9910392.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,9910392+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9910392.target)
	e1:SetOperation(c9910392.activate)
	c:RegisterEffect(e1)
end
function c9910392.tdfilter(c,e,tp)
	return c:IsFaceupEx() and c:IsType(TYPE_FIELD) and c:IsAbleToDeck()
		and Duel.IsExistingMatchingCard(c9910392.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c)
end
function c9910392.spfilter(c,e,tp,mc)
	return c:IsSetCard(0x5951) and aux.IsCodeListed(mc,c:GetCode()) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9910392.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9910392.tdfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_ONFIELD+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c9910392.activate(e,tp,eg,ep,ev,re,r,rp)
	local count=2
	while count>0 do
		Duel.AdjustAll()
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(c9910392.tdfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil,e,tp)
			and (count==2 or Duel.SelectYesNo(tp,aux.Stringid(9910392,0))) then
			if count<2 then Duel.BreakEffect() end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local g=Duel.SelectMatchingCard(tp,c9910392.tdfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil,e,tp)
			Duel.HintSelection(g)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=Duel.SelectMatchingCard(tp,c9910392.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,g:GetFirst())
			if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)==0 or Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)==0
				or not g:GetFirst():IsLocation(LOCATION_DECK+LOCATION_EXTRA) then return end
			count=count-1
		else
			count=0
		end
	end
end
