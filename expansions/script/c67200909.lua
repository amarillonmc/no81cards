--奥山修正者 铃兰之弦
function c67200909.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--move
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200909,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,67200909)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c67200909.mvtg)
	e1:SetOperation(c67200909.mvop)
	c:RegisterEffect(e1)
	--spsummon spell
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67200909,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,67200910)
	e2:SetCondition(c67200909.spscon)
	e2:SetTarget(c67200909.spstg)
	e2:SetOperation(c67200909.spsop)
	c:RegisterEffect(e2)
	--spsummon from GY
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67200909,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_DECK)
	e3:SetCountLimit(1,67200910)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c67200909.spcon)
	e3:SetTarget(c67200909.sptg)
	e3:SetOperation(c67200909.spop)
	c:RegisterEffect(e3)
end
function c67200909.filter(c,tp)
	local r=LOCATION_REASON_TOFIELD
	--if not c:IsControler(c:GetOwner()) then r=LOCATION_REASON_CONTROL end
	return c:IsType(TYPE_PENDULUM) and c:IsFaceupEx()
		and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
end
function c67200909.mvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_MZONE) and c67200909.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c67200909.filter,tp,LOCATION_GRAVE+LOCATION_MZONE,LOCATION_GRAVE+LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c67200909.filter,tp,LOCATION_GRAVE+LOCATION_MZONE,LOCATION_GRAVE+LOCATION_MZONE,1,1,nil)
	if g:GetFirst():IsLocation(LOCATION_GRAVE) then
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
	end
end
function c67200909.mvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.MoveToField(tc,tp,tc:GetOwner(),LOCATION_PZONE,POS_FACEUP,true)
	end
end
function c67200909.spscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function c67200909.sfilter(c,e,tp)
	return c:IsType(TYPE_PENDULUM)
		and c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c67200909.spstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_PZONE) and c67200909.sfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c67200909.sfilter,tp,LOCATION_PZONE,LOCATION_PZONE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c67200909.sfilter,tp,LOCATION_PZONE,LOCATION_PZONE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c67200909.spsop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) end
end
function c67200909.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND+LOCATION_ONFIELD) and e:GetHandler():IsFaceup()
end
function c67200909.ffilter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsSetCard(0x67a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c67200909.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCountFromEx(tp,tp,nil,c)>1
		and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.IsExistingMatchingCard(c67200909.ffilter,tp,LOCATION_EXTRA,0,2,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_EXTRA)
end
function c67200909.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp,tp,nil,c)<=1 or Duel.IsPlayerAffectedByEffect(tp,59822133)
		or Duel.GetMatchingGroupCount(c67200909.ffilter,tp,LOCATION_EXTRA,0,nil,e,tp)<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c67200909.ffilter,tp,LOCATION_EXTRA,0,2,2,nil,e,tp)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end

