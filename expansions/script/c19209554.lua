--心象风景 唯我
function c19209554.initial_effect(c)
	aux.AddCodeList(c,19209516)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,19209554+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c19209554.condition)
	e1:SetTarget(c19209554.target)
	e1:SetOperation(c19209554.activate)
	c:RegisterEffect(e1)
end
function c19209554.chkfilter(c)
	return c:IsCode(19209516) and c:IsFaceup()
end
function c19209554.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c19209554.chkfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c19209554.disfilter(c)
	return not c:IsCode(19209516) and c:IsSetCard(0xb50) and aux.NegateAnyFilter(c)
end
function c19209554.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,nil) and Duel.IsExistingMatchingCard(c19209554.disfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
end
function c19209554.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,nil)
	if ct==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local g=Duel.SelectMatchingCard(tp,c19209554.disfilter,tp,LOCATION_ONFIELD,0,1,ct,aux.ExceptThisCard(e))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local g2=Duel.SelectMatchingCard(tp,aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,#g,#g,nil)
	g:Merge(g2)
	for tc in aux.Next(g) do
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		tc:RegisterEffect(e2)
	end
end
