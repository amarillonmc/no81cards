--地 狱 恶 魔 的 嬉 闹
local m=22348141
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c22348141.condition)
	e1:SetCost(c22348141.cost)
	e1:SetTarget(c22348141.target)
	e1:SetOperation(c22348141.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c22348141.handcon)
	c:RegisterEffect(e2)
	--apply effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22349141,0))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCountLimit(1,22349141)
	e3:SetTarget(c22348141.efftg)
	e3:SetOperation(c22348141.effop)
	c:RegisterEffect(e3)
end
function c22348141.handcon(e)
	return Duel.IsEnvironment(94585852)
end

function c22348141.cfilter(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsSetCard(0x705) and c:IsAbleToRemoveAsCost()
end
function c22348141.condition(e,tp,eg,ep,ev,re,r,rp)
	return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c22348141.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c22348141.cfilter),tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c22348141.cfilter),tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c22348141.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c22348141.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c22348141.efffilter(c,e,tp,eg,ep,ev,re,r,rp)
	if not (c:IsSetCard(0x705) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove())
	then return false end
	local te=c.onfield_effect
	if not te then return false end
	local tg=te:GetTarget()
	return not tg or tg and tg(e,tp,eg,ep,ev,re,r,rp,0)
end
function c22348141.efftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348141.efffilter,tp,LOCATION_DECK+LOCATION_MZONE,0,1,nil,e,tp,eg,ep,ev,re,r,rp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK+LOCATION_MZONE)
end
function c22348141.effop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c22348141.efffilter,tp,LOCATION_DECK+LOCATION_MZONE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	local te=tc.onfield_effect
	local op=te:GetOperation()
	if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and op then op(e,tp,eg,ep,ev,re,r,rp) end
end







