--心象风景 引燃
function c19209555.initial_effect(c)
	aux.AddCodeList(c,19209519)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,19209555+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c19209555.condition)
	e1:SetTarget(c19209555.target)
	e1:SetOperation(c19209555.activate)
	c:RegisterEffect(e1)
end
function c19209555.chkfilter(c)
	return c:IsCode(19209519) and c:IsFaceup()
end
function c19209555.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c19209555.chkfilter,tp,LOCATION_EXTRA+LOCATION_REMOVED,0,1,nil)
end
function c19209555.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c19209555.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local code=tc:GetCode()
	local tpe=tc:GetType()
	local g=Group.CreateGroup()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		g:AddCard(tc)
		local dg=Duel.GetMatchingGroup(Card.IsCode,tp,0,LOCATION_HAND+LOCATION_DECK,nil,code)
		if bit.band(tpe,TYPE_TOKEN)==0 and #dg~=0 then
			Duel.BreakEffect()
			Duel.Destroy(dg,REASON_EFFECT)
			local og=Duel.GetOperatedGroup()
			g:Merge(og)
		end
	end
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetRange(LOCATION_GRAVE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
