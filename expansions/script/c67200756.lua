--噩梦回廊散化
function c67200756.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c67200756.condition)
	e1:SetTarget(c67200756.target)
	e1:SetOperation(c67200756.activate)
	c:RegisterEffect(e1)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetTarget(c67200756.atktg)
	e3:SetValue(1000)
	c:RegisterEffect(e3)
end
function c67200756.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x67d) and c:IsType(TYPE_PENDULUM)
end
function c67200756.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c67200756.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsChainNegatable(ev) and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function c67200756.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c67200756.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
--
function c67200756.atktg(e,c)
	return c:IsSetCard(0x67d) and c:IsType(TYPE_PENDULUM)
end
