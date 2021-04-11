--Tender Thoughts
function c60151423.initial_effect(c)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,60151423+EFFECT_COUNT_CODE_OATH)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c60151423.discon)
	e1:SetTarget(c60151423.distg)
	e1:SetOperation(c60151423.disop)
	c:RegisterEffect(e1)
	--remain field
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e2)
end
function c60151423.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainNegatable(ev)
end
function c60151423.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x3b28) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c60151423.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c60151423.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c60151423.filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToDeck() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
	end
end
function c60151423.disop(e,tp,eg,ep,ev,re,r,rp)
	local ec=re:GetHandler()
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		if re:GetHandler():IsType(TYPE_MONSTER) then
			if Duel.SendtoDeck(eg,nil,2,REASON_EFFECT)>0 then
				Duel.BreakEffect()
				local tc=Duel.GetFirstTarget()
				if tc and tc:IsRelateToEffect(e) then
					Duel.SendtoHand(tc,nil,REASON_EFFECT)
				end
			end
		else
			ec:CancelToGrave()
			if Duel.SendtoDeck(eg,nil,2,REASON_EFFECT)>0 then
				Duel.BreakEffect()
				local tc=Duel.GetFirstTarget()
				if tc and tc:IsRelateToEffect(e) then
					Duel.SendtoHand(tc,nil,REASON_EFFECT)
				end
			end
		end
	end
end
