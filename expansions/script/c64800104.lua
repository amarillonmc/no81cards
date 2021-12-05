--神代丰的激斗 东瀛大赏
function c64800104.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,64800104)
	e1:SetCondition(c64800104.condition)
	e1:SetTarget(c64800104.target)
	e1:SetOperation(c64800104.activate)
	c:RegisterEffect(e1)
end

--e1
function c64800104.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x641a) and not c:IsCode(64800097)
end
function c64800104.sfilter(c)
	return c:IsFaceup() and c:IsCode(64800097)
end
function c64800104.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c64800104.cfilter,tp,LOCATION_MZONE,0,1,nil) and ep~=tp
		and Duel.IsChainNegatable(ev) and (re:IsHasType(EFFECT_TYPE_ACTIVATE) or (re:IsActiveType(TYPE_MONSTER) 
		and Duel.IsExistingMatchingCard(c64800104.sfilter,tp,LOCATION_SZONE,0,1,nil)))
end
function c64800104.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.nbcon(tp,re) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c64800104.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end