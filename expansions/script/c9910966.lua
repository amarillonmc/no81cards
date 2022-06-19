--逐彩的永夏 七海
function c9910966.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9910966)
	e1:SetCost(c9910966.spcost)
	e1:SetTarget(c9910966.sptg)
	e1:SetOperation(c9910966.spop)
	c:RegisterEffect(e1)
end
function c9910966.tdfilter(c)
	return c:IsFacedown() and c:IsAbleToDeckOrExtraAsCost()
end
function c9910966.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910966.tdfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,4,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c9910966.tdfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,4,4,nil)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c9910966.spfilter(c,e,tp)
	return c:IsSetCard(0x5954) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9910966.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp,e:GetHandler())>0
		and Duel.IsExistingMatchingCard(c9910966.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c9910966.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Duel.SelectMatchingCard(tp,c9910966.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
		if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9910966,0))
			local lv=Duel.AnnounceNumber(tp,1,2,3)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_LEVEL)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(lv)
			tc:RegisterEffect(e1)
		end
		Duel.SpecialSummonComplete()
	end
end
