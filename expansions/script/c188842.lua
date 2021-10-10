--
function c188842.initial_effect(c)
	--add counter
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(188842,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_END_PHASE,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,188842)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c188842.target)
	e1:SetOperation(c188842.operation)
	c:RegisterEffect(e1)
	local e0=e1:Clone()
	e0:SetRange(LOCATION_HAND)
	c:RegisterEffect(e0)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(188842,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMING_END_PHASE,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,188842+100)
	e2:SetTarget(c188842.destg)
	e2:SetOperation(c188842.desop)
	c:RegisterEffect(e2)
end
c188842.counter_add_list={0x10cb}
function c188842.counterfilter(c)
	return c:IsSetCard(0xcab) and (c:IsPublic() and c:IsLocation(LOCATION_HAND)) or (c:IsFaceup() and c:IsLocation(LOCATION_ONFIELD))
end
function c188842.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
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
function c188842.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_HAND) and c:IsPublic() then return false end
	local ct=Duel.GetMatchingGroupCount(c188842.counterfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,LOCATION_HAND+LOCATION_ONFIELD,c)
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
function c188842.filter(c,e,tp)
	local ct=c:GetCounter(0x10cb)
	return ct>0 and c:IsFaceup()
end
function c188842.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:GetCounter(0x10cb)>0 and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c188842.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c188842.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp)
	e:SetLabelObject(g:GetFirst())
end
function c188842.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local ct=tc:GetCounter(0x10cb)
	if ct>0 then
		tc:RemoveCounter(tp,0x10cb,ct,REASON_EFFECT)
	else return false end
	local num=math.floor(ct/2)
	local g=Group.CreateGroup()
	if num>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0,num,nil)
	end
	if num==0 or g:GetCount()==0 then return end
	Duel.BreakEffect()
	Duel.Destroy(g,REASON_EFFECT)
end
