--独角兽改
function c25800007.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,25800006,aux.FilterBoolFunction(Card.IsFusionSetCard,0x6211),1,false,false)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(25800007,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMING_MAIN_END+TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,25800007)
	e1:SetCondition(c25800007.spcon)
	e1:SetTarget(c25800007.sptg)
	e1:SetOperation(c25800007.spop)
	c:RegisterEffect(e1)

	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c25800007.reccon)
	e2:SetOperation(c25800007.recop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end

function c25800007.spcon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
		
end
function c25800007.spfilter(c,e,tp)
	return c:IsSetCard(0x211) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c25800007.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c25800007.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c25800007.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c25800007.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
---2
function c25800007.cfilter(c,tp)
	return c:IsSummonPlayer(tp)
end
function c25800007.reccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c25800007.cfilter,1,nil,1-tp)
end
function c25800007.recop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,25800007)
	Duel.Recover(tp,500,REASON_EFFECT)
end

