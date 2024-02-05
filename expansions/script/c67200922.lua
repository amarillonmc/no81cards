--众星修正者 怒蛇
function c67200922.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)  
	--spsummon self
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200922,0))
	e1:SetCategory(CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,67200922)
	e1:SetCondition(c67200922.spscon)
	e1:SetTarget(c67200922.spstg)
	e1:SetOperation(c67200922.spsop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67200922,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_DECK)
	e2:SetCountLimit(1,67200923)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c67200922.spcon)
	e2:SetTarget(c67200922.sptg)
	e2:SetOperation(c67200922.spop)
	c:RegisterEffect(e2)
end
function c67200922.spscon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c67200922.filter(c,tp)
	return c:IsFaceupEx() and c:IsSetCard(0x67a) and c:IsType(TYPE_PENDULUM) and Duel.GetMZoneCount(tp,c)>0
end
function c67200922.spstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c67200922.filter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,c,tp)
	if chk==0 then return #g>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c67200922.spsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(67200922,3))
	local g=Duel.SelectMatchingCard(tp,c67200922.filter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,aux.ExceptThisCard(e),tp)
	if Duel.SendtoExtraP(g,nil,REASON_EFFECT)>0 and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c67200922.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_EXTRA)
end
function c67200922.sfilter(c,e,tp)
	return c:IsSetCard(0x67a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(67200922) and c:IsFaceup()
end
function c67200922.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
		and Duel.IsExistingMatchingCard(c67200922.sfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c67200922.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c67200922.sfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0
		and g:GetFirst():IsSetCard(0xa67a) and Duel.SelectYesNo(tp,aux.Stringid(67200922,2)) then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local sg=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD):FilterSelect(tp,Card.IsAbleToHand,1,1,nil)
		Duel.HintSelection(sg)
		Duel.BreakEffect()
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end

