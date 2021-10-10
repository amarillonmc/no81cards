--
function c188841.initial_effect(c)
	--add counter
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(188841,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_END_PHASE,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,188841)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c188841.target)
	e1:SetOperation(c188841.operation)
	c:RegisterEffect(e1)
	local e0=e1:Clone()
	e0:SetRange(LOCATION_HAND)
	c:RegisterEffect(e0)
	--atkdown
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(c188841.atktg)
	e2:SetValue(c188841.atkval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetRange(LOCATION_HAND)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e5)
end
c188841.counter_add_list={0x10cb}
function c188841.counterfilter(c)
	return c:IsSetCard(0xcab) and ((c:IsPublic() and c:IsLocation(LOCATION_HAND)) or (c:IsFaceup() and c:IsLocation(LOCATION_ONFIELD)))
end
function c188841.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct=0
	local c=e:GetHandler()
	ct=Duel.GetMatchingGroupCount(c188840.counterfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,LOCATION_HAND+LOCATION_ONFIELD,e:GetHandler())
	if c:IsOnField() then ct=ct+1 end
	if chkc then return chkc:IsCanAddCounter(0x10cb,ct+1) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsCanAddCounter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,0x10cb,ct+1) and (not c:IsPublic() and c:IsLocation(LOCATION_HAND)) or (c:IsFaceup() and c:IsLocation(LOCATION_ONFIELD))  end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,Card.IsCanAddCounter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,0x10cb,ct+1)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,ct+1,0,0)
end
function c188841.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_HAND) and c:IsPublic() then return false end
	local ct=Duel.GetMatchingGroupCount(c188841.counterfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,LOCATION_HAND+LOCATION_ONFIELD,c)
	if c:IsOnField() then ct=ct+1 end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsCanAddCounter(0x10cb,ct+1) then
		tc:AddCounter(0x10cb,ct+1)
		Duel.RaiseEvent(tc,EVENT_CUSTOM+54306223,e,0,0,0,0)
		if c:IsLocation(LOCATION_HAND) and not c:IsPublic() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_PUBLIC)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1)
		end
	end
end
function c188841.atktg(e,c)
	local ac=e:GetHandler()
	return (ac:IsPublic() and ac:IsLocation(LOCATION_HAND)) or (ac:IsFaceup() and ac:IsLocation(LOCATION_ONFIELD))
end
function c188841.atkval(e,c)
	return Duel.GetCounter(0,1,1,0x10cb)*-200
end
