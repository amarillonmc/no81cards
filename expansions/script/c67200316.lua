--结天缘神 魔力引渡
function c67200316.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCondition(c67200316.condition)
	e1:SetTarget(c67200316.target)
	e1:SetOperation(c67200316.activate)
	c:RegisterEffect(e1)	
end
--
function c67200316.actfilter(c)
	return c:IsFaceup() and c:GetSequence()<5
end
function c67200316.condition(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==1
		and Duel.IsExistingMatchingCard(c67200316.actfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c67200316.setfilter(c)
	return c:IsSetCard(0x671) and c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function c67200316.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200316.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function c67200316.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c67200316.setfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SSet(tp,tc)~=0 then
		Duel.BreakEffect()
		c:CancelToGrave()   
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(67200316,2))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		c:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetDescription(aux.Stringid(67200316,2))
		e2:SetCategory(CATEGORY_TOHAND)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e2:SetCode(EVENT_TO_HAND)
		e2:SetRange(LOCATION_SZONE)
		e2:SetProperty(EFFECT_FLAG_DELAY)
		e2:SetCondition(c67200316.thcon)
		e2:SetTarget(c67200316.thtg)
		e2:SetOperation(c67200316.thop)
		c:RegisterEffect(e2)
	end
end
--
function c67200316.cfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP) and c:IsSetCard(0x671)
end
function c67200316.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c67200316.cfilter,1,nil,tp)
end
function c67200316.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c67200316.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
end


