--冰炮之御咒姬
function c67200903.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67200903,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,67200903)
	e2:SetCondition(c67200903.spcon)
	e2:SetTarget(c67200903.sptg)
	e2:SetOperation(c67200903.spop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67200903,1))
	--e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_DECK)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	--e3:SetRange(LOCATION_HAND)
	--e3:SetCountLimit(1,67200902)
	e3:SetCondition(c67200903.stcon)
	e3:SetTarget(c67200903.sttg)
	e3:SetOperation(c67200903.stop)
	c:RegisterEffect(e3)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67200903,2))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,67200904)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetTarget(c67200903.destg)
	e2:SetOperation(c67200903.desop)
	c:RegisterEffect(e2)
end
function c67200903.spfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsSetCard(0x67a) 
end
function c67200903.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c67200903.spfilter,1,nil,tp)
end
function c67200903.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c67200903.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end
--
function c67200903.stcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND+LOCATION_DECK) and e:GetHandler():IsFaceup()
end
function c67200903.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c67200903.stop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
--
function c67200903.desfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x367a) and c:IsType(TYPE_PENDULUM) and Duel.IsExistingMatchingCard(nil,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)
end
function c67200903.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200903.desfilter1,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,2,0,0)
end
function c67200903.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g1=Duel.SelectMatchingCard(tp,c67200903.desfilter1,tp,LOCATION_ONFIELD,0,1,1,nil)
	if #g1==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g2=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,g1)
	g1:Merge(g2)
	Duel.HintSelection(g1)
	Duel.SendtoHand(g1,nil,REASON_EFFECT)
end