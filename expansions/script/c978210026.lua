--多元闪刀姬衍生物∞
function c978210026.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(978210026,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c978210026.spcost1)
	e1:SetTarget(c978210026.sptg1)
	e1:SetOperation(c978210026.spop1)
	c:RegisterEffect(e1)
end
function c978210026.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c978210026.spfilter1(c,e,tp,ec)
	return c:IsSetCard(0x2115) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,ec,c,0x60)>0
end
function c978210026.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c978210026.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c978210026.spop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c978210026.spfilter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,e:GetHandler())
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,0x60)
	end
end