--真红眼不死炎
function c98920768.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,98920768+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c98920768.cost)
	e1:SetCondition(c98920768.condition)
	e1:SetTarget(c98920768.target)
	e1:SetOperation(c98920768.activate)
	c:RegisterEffect(e1)	
end
function c98920768.cfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x3b) and c:IsLevelAbove(7)
end
function c98920768.cfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsRace(RACE_ZOMBIE)
end
function c98920768.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,700) end
	Duel.PayLPCost(tp,700)
end
function c98920768.condition(e,tp,eg,ep,ev,re,r,rp)
	return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
		and (Duel.IsExistingMatchingCard(c98920768.cfilter1,tp,LOCATION_MZONE,0,1,nil)
		or Duel.IsExistingMatchingCard(c98920768.cfilter2,tp,LOCATION_MZONE,0,1,nil))
end
function c98920768.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) and re:GetHandler():IsDestructable() then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c98920768.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
	local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(c98920768.cfilter1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c98920768.cfilter2,tp,LOCATION_MZONE,0,1,nil) and c:IsRelateToEffect(e) and c:IsCanTurnSet() then
		Duel.BreakEffect()
		c:CancelToGrave()
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
end