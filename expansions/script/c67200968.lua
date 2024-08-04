--奥山修正者 幽月
function c67200968.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x67a),2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67200968,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e3:SetCountLimit(1)
	e3:SetTarget(c67200968.sptg)
	e3:SetOperation(c67200968.spop)
	c:RegisterEffect(e3)
end
function c67200968.spfilter(c,e,tp,zone)
	return c:IsSetCard(0x367a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE,tp,zone) and c:IsType(TYPE_PENDULUM)
end
function c67200968.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local zone=bit.band(e:GetHandler():GetLinkedZone(tp),0x1f)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c67200968.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,zone) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c67200968.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local zone=bit.band(e:GetHandler():GetLinkedZone(tp),0x1f)
	if zone==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c67200968.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,zone)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE,zone)
	end
end
