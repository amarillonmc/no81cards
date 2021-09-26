--混合咖啡的盛情调制
function c9910578.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_DISABLE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,9910578+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c9910578.cost)
	e1:SetTarget(c9910578.target)
	e1:SetOperation(c9910578.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(9910578,ACTIVITY_CHAIN,c9910578.chainfilter)
end
function c9910578.chainfilter(re,tp,cid)
	local rc=re:GetHandler()
	return not (re:IsActiveType(TYPE_MONSTER) and not rc:IsLocation(LOCATION_MZONE)
		and rc:IsType(TYPE_RITUAL+TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_PENDULUM+TYPE_LINK))
end
function c9910578.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(9910578,tp,ACTIVITY_CHAIN)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetValue(c9910578.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9910578.aclimit(e,re,tp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and not rc:IsLocation(LOCATION_MZONE)
		and rc:IsType(TYPE_RITUAL+TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_PENDULUM+TYPE_LINK)
end
function c9910578.desfilter(c,g)
	return g:IsContains(c)
end
function c9910578.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	if tc:IsFaceup() then
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,tc,1,0,0)
	else
		local g2=Duel.GetMatchingGroup(c9910578.desfilter,tp,0,LOCATION_ONFIELD,nil,tc:GetColumnGroup())
		g:Merge(g2)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	end
end
function c9910578.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or not tc:IsOnField() then return end
	if tc:IsFaceup() then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(math.ceil(tc:GetAttack()/2))
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e2:SetValue(math.ceil(tc:GetDefense()/2))
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_DISABLE_EFFECT)
		e4:SetValue(RESET_TURN_SET)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e4)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_MUST_ATTACK)
		e5:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e5)
		local e6=e5:Clone()
		e6:SetCode(EFFECT_MUST_ATTACK_MONSTER)
		e6:SetValue(c9910578.atklimit)
		tc:RegisterEffect(e6)
	else
		local g=Duel.GetMatchingGroup(c9910578.desfilter,tp,0,LOCATION_ONFIELD,nil,tc:GetColumnGroup())
		g:AddCard(tc)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c9910578.atklimit(e,c)
	return c:IsFacedown()
end
