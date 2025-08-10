--邪智的魅力
function c22024170.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,22024170+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c22024170.spcon)
	e1:SetTarget(c22024170.target)
	e1:SetOperation(c22024170.activate)
	c:RegisterEffect(e1)
end
function c22024170.cfilter(c,p)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(p)
end
function c22024170.spcon(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c22024170.cfilter,nil,1-tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
			tc=g:GetNext()
		end
		return true
	else return false end
end
function c22024170.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c22024170.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22024170.filter,tp,LOCATION_MZONE,0,1,nil) end
end
function c22024170.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c22024170.filter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(1250)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
	if c:IsRelateToEffect(e) and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.BreakEffect()
		c:CancelToGrave()
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end