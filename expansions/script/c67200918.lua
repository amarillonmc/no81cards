--废都魔翼·灭世
function c67200918.initial_effect(c) 
	aux.EnablePendulumAttribute(c) 
	--pendulum set
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,67200918)
	e1:SetCondition(c67200918.pencon)
	e1:SetTarget(c67200918.pentg)
	e1:SetOperation(c67200918.penop)
	c:RegisterEffect(e1)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67200918,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_DECK)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,67200919)
	e3:SetCondition(c67200918.stcon)
	e3:SetTarget(c67200918.sttg)
	e3:SetOperation(c67200918.stop)
	c:RegisterEffect(e3)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67200918,2))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetTarget(c67200918.target)
	e2:SetOperation(c67200918.operation)
	c:RegisterEffect(e2)
end
function c67200918.cfilter(c)
	return c:IsSetCard(0x967a)
end
function c67200918.pencon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c67200918.cfilter,tp,LOCATION_PZONE,0,1,e:GetHandler())
end
function c67200918.spfilter2(c,e,tp)
	return c:IsSetCard(0x967a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c67200918.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>=2 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
		and Duel.IsExistingMatchingCard(c67200918.spfilter2,tp,LOCATION_PZONE,0,1,c,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,2,tp,LOCATION_PZONE)
end
function c67200918.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsCanBeSpecialSummoned(e,0,tp,false,false) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c67200918.spfilter2,tp,LOCATION_PZONE,0,1,1,c,e,tp)
	if g:GetCount()>0 then
		g:AddCard(c)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
--
function c67200918.stcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFaceup()
end
function c67200918.stfilter(c)
	return c:IsSetCard(0x67a) and c:IsType(TYPE_PENDULUM) and c:IsFaceup() and not c:IsForbidden() 
end
function c67200918.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) and Duel.CheckLocation(tp,LOCATION_PZONE,1) and not e:GetHandler():IsForbidden() and Duel.IsExistingMatchingCard(c67200918.stfilter,tp,LOCATION_EXTRA,0,1,e:GetHandler()) end
end
function c67200918.stop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if (Duel.CheckLocation(tp,LOCATION_PZONE,0) and Duel.CheckLocation(tp,LOCATION_PZONE,1)) and c:IsRelateToEffect(e) then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,c67200918.stfilter,tp,LOCATION_EXTRA,0,1,1,e:GetHandler())
		local tc=g:GetFirst()
		if tc then
			if Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)~=0 then
				Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
			end
		end
	end
end
--

function c67200918.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c67200918.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsControler(1-tp) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end

