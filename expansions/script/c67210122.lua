--夏乡净梦 秋津圆香
function c67210122.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67210122,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,67210122)
	e1:SetTarget(c67210122.pltg)
	e1:SetOperation(c67210122.plop)
	c:RegisterEffect(e1) 
	--fusion
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67210122,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_DECK)
	e2:SetCountLimit(1,67210120)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c67210122.condition)
	e2:SetTarget(c67210122.target)
	e2:SetOperation(c67210122.activate)
	c:RegisterEffect(e2)	  
end
--P effect
function c67210122.pltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c67210122.plop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Exile(c,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(67210122,1))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		c:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetCategory(CATEGORY_TOEXTRA)
		e2:SetType(EFFECT_TYPE_QUICK_O)
		e2:SetRange(LOCATION_SZONE)
		e2:SetCode(EVENT_FREE_CHAIN)
		e2:SetCountLimit(1)
		e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
		e2:SetTarget(c67210122.thtg)
		e2:SetOperation(c67210122.thop)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e2)
	end
end
function c67210122.thfilter(c)
	return c:IsSetCard(0x567e) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c67210122.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
end
function c67210122.filter(c)
	return bit.band(c:GetOriginalType(),TYPE_PENDULUM)==TYPE_PENDULUM
end
function c67210122.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(67210122,0))
	local gg=Duel.SelectMatchingCard(tp,c67210122.filter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	if gg:GetCount()>0 then
		Duel.SendtoExtraP(gg,nil,REASON_EFFECT)
	end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(aux.TargetBoolFunction(Card.IsCode,67210111))
		e1:SetValue(c67210122.efilter)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
end
function c67210122.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
--
--moster effect
function c67210122.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_EXTRA) and not e:GetHandler():IsPreviousLocation(LOCATION_DECK)
end
function c67210122.filter11(c,e,tp)
	return ((c:IsLocation(LOCATION_DECK) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) or
		(c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCode(67210111)
end
function c67210122.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67210122.filter11,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c67210122.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c67210122.filter11,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

