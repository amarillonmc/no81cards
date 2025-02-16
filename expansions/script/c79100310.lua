--律法塔魂的决战兵器 法艾特
function c79100310.initial_effect(c)
	c:EnableCounterPermit(0xa11)
	c:SetCounterLimit(0xa11,3)
	c:SetUniqueOnField(1,0,79100310)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode2FunRep(c,79100260,79100270,aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_DARK),1,1,true,true)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.fuslimit)
	c:RegisterEffect(e0)
	--add counter
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(aux.chainreg)
	c:RegisterEffect(e1)
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e11:SetCode(EVENT_CHAIN_SOLVING)
	e11:SetProperty(EFFECT_FLAG_DELAY)
	e11:SetRange(LOCATION_MZONE)
	e11:SetOperation(c79100310.acop)
	c:RegisterEffect(e11)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79100310,2))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_F)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c79100310.condition)
	e2:SetCost(c79100310.cost)
	e2:SetTarget(c79100310.target)
	e2:SetOperation(c79100310.operation)
	c:RegisterEffect(e2)
end
function c79100310.acop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(FLAG_ID_CHAINING)>0 and rp==1-tp then
		e:GetHandler():AddCounter(0xa11,1)
	end
end
function c79100310.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and not c:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c79100310.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanRemoveCounter(tp,0xa11,3,REASON_COST) end
	c:RemoveCounter(tp,0xa11,3,REASON_COST)
end
function c79100310.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c79100310.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end