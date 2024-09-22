--异天枝-拉斐尔
function c22060180.initial_effect(c)
	--Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22060180,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(8,22060180)
	e1:SetCost(c22060180.cost)
	e1:SetTarget(c22060180.target)
	e1:SetOperation(c22060180.operation)
	c:RegisterEffect(e1)
end
function c22060180.cfilter(c)
	return c:IsType(TYPE_MONSTER)and c:IsDiscardable()
end
function c22060180.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsPublic() and Duel.IsExistingMatchingCard(c22060180.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,c22060180.cfilter,1,1,REASON_COST+REASON_DISCARD,e:GetHandler())
end
function c22060180.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c22060180.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22060180.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c22060180.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c22060180.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c22060180.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
