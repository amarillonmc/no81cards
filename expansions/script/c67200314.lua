--结天缘神 会心一击！
function c67200314.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCondition(c67200314.condition)
	e1:SetTarget(c67200314.target)
	e1:SetOperation(c67200314.activate)
	c:RegisterEffect(e1)
end
--
function c67200314.actfilter(c)
	return c:IsFaceup() and c:GetSequence()<5
end
function c67200314.condition(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==1
		and Duel.IsExistingMatchingCard(c67200314.actfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c67200314.thfilter(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
function c67200314.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(c67200314.thfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c67200314.thfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c67200314.plfilter(c)
	return c:IsCode(67200311) and not c:IsForbidden()
end
function c67200314.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
		local dg=Duel.GetMatchingGroup(c67200314.actfilter,tp,LOCATION_MZONE,0,nil)
		local tdg=dg:GetFirst()
		if dg:GetCount()==1 and tdg:IsSetCard(0x671) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c67200314.plfilter,tp,LOCATION_DECK,0,1,nil,tp) and Duel.SelectYesNo(tp,aux.Stringid(67200314,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
			local g2=Duel.SelectMatchingCard(tp,c67200314.plfilter,tp,LOCATION_DECK,0,1,1,nil)
			local tcc=g2:GetFirst()
			if tcc then
				Duel.MoveToField(tcc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetDescription(aux.Stringid(67200314,2))
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CHANGE_TYPE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
				e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
				tcc:RegisterEffect(e1,true)
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetCategory(CATEGORY_TOHAND)
				e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
				e2:SetCode(EVENT_TO_HAND)
				e2:SetRange(LOCATION_SZONE)
				e2:SetProperty(EFFECT_FLAG_DELAY)
				e2:SetCondition(c67200314.thcon)
				e2:SetTarget(c67200314.thtg)
				e2:SetOperation(c67200314.thop)
				tcc:RegisterEffect(e2)
			end
		end
	end
end
--
function c67200314.cfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP) and c:IsSetCard(0x671)
end
function c67200314.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c67200314.cfilter,1,nil,tp)
end
function c67200314.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c67200314.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
end
