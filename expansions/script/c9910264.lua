--幽鬼舞步
function c9910264.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c9910264.condition)
	e1:SetTarget(c9910264.target)
	e1:SetOperation(c9910264.activate)
	c:RegisterEffect(e1)
end
function c9910264.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x11b) and c:IsType(TYPE_LINK)
end
function c9910264.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,0,1,nil,0x953,1)
		and Duel.IsChainNegatable(ev) and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function c9910264.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.nbcon(tp,re)
		and Duel.IsExistingMatchingCard(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,0,1,nil,0x953,1) end
	local g=Duel.GetMatchingGroup(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,0,nil,0x953,1)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,g,#g,0,0)
end
function c9910264.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,0,nil,0x953,1)
	if g:GetCount()==0 then return end
	for tc in aux.Next(g) do
		if tc:IsCanAddCounter(0x953,1) then
			tc:AddCounter(0x953,1)
		end
	end
	if Duel.GetCounter(tp,1,0,0x953)>=6 then
		if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
			Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
		end
	else
		if c:IsRelateToEffect(e) and c:IsCanTurnSet() then
			Duel.BreakEffect()
			c:CancelToGrave()
			Duel.ChangePosition(c,POS_FACEDOWN)
			Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		end
	end
end
