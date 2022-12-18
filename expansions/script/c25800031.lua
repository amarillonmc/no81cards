--小企业
function c25800031.initial_effect(c)
   
aux.EnableChangeCode(c,25800040,LOCATION_MZONE+LOCATION_GRAVE)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(25800031,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,25800031)
	e1:SetCondition(c25800031.spcon1)

	e1:SetTarget(c25800031.sptg1)
	e1:SetOperation(c25800031.spop1)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(25800031,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMING_END_PHASE+TIMINGS_CHECK_MONSTER)
	e2:SetCountLimit(1,25800032)
	e2:SetCost(c25800031.spcost)
	e2:SetTarget(c25800031.sptg)
	e2:SetOperation(c25800031.spop)
	c:RegisterEffect(e2)
end
function c25800031.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c25800031.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c25800031.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
------2
function c25800031.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c25800031.spfilter(c,e,tp)
	return c:IsSetCard(0xa211) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c25800031.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return 
	   Duel.IsExistingMatchingCard(c25800031.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c25800031.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c25800031.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
