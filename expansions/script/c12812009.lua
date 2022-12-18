--先告白的人即为输家
local m=12812009
local cm=_G["c"..m]
function c12812009.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(cm.condition)
    e1:SetCost(cm.spcost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.cfilter(c)
	return c:IsSetCard(0xa73) and c:IsType(TYPE_MONSTER)
end
function cm.spcostfil(c,e,tp)
	return c:IsSetCard(0xa73) and c:IsAbleToRemoveAsCost() and c:IsType(TYPE_PENDULUM) and c:IsFaceup()
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.spcostfil,tp,LOCATION_EXTRA,0,nil,e,tp)
	if chk==0 then return g:GetCount()>0 end
	local sg=g:Select(tp,1,1,nil)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsChainNegatable(ev) and re:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.nbcon(tp,re) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end