--明治维新·倒幕运动
function c9951281.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c9951281.condition)
	e1:SetTarget(c9951281.target)
	e1:SetOperation(c9951281.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c9951281.handcon)
	c:RegisterEffect(e2)
end
function c9951281.handcon(e)
	return Duel.GetMatchingGroupCount(c9951281.cfilter,e:GetHandler():GetControler(),LOCATION_MZONE+LOCATION_GRAVE,0,nil)>2
end
function c9951281.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x5ba5) and c:IsType(TYPE_MONSTER)
end
function c9951281.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9951281.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
		and Duel.IsChainNegatable(ev) and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function c9951281.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.nbcon(tp,re) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c9951281.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end