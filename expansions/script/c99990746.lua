--最后的潜海奇袭
function c99990746.initial_effect(c)
	aux.AddCodeList(c,22702055)
	--code
	aux.EnableChangeCode(c,22702055,LOCATION_SZONE)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,99990746)
	e1:SetTarget(c99990746.target)
	e1:SetOperation(c99990746.operation)
	c:RegisterEffect(e1)
end
function c99990746.spfilter(c,e,tp)
	return aux.IsCodeListed(c,22702055) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99990746.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c99990746.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND)
end
function c99990746.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c99990746.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end