local m=82228573
local cm=_G["c"..m]
function cm.initial_effect(c)
	--activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(cm.condition)  
	c:RegisterEffect(e1)  
	--indes  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)  
	e2:SetRange(LOCATION_SZONE)  
	e2:SetTargetRange(LOCATION_FZONE,LOCATION_FZONE)  
	e2:SetTarget(aux.TargetBoolFunction(Card.IsCode,82228562))  
	e2:SetValue(1)  
	c:RegisterEffect(e2)  
	--negate  
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,1))  
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)  
	e3:SetType(EFFECT_TYPE_ACTIVATE)  
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)  
	e3:SetCode(EVENT_CHAINING)  
	e3:SetRange(LOCATION_SZONE)  
	e3:SetCountLimit(1)  
	e3:SetCondition(cm.negcon)  
	e3:SetCost(cm.negcost)  
	e3:SetTarget(cm.negtg)  
	e3:SetOperation(cm.negop)  
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)  
	e4:SetRange(LOCATION_SZONE)  
	c:RegisterEffect(e4) 
end  
function cm.condition(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()  
end  
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)  
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)  
end  
function cm.cfilter(c)  
	return c:IsSetCard(0x297) and c:IsDiscardable()  
end  
function cm.negcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND,0,1,nil) end  
	Duel.DiscardHand(tp,cm.cfilter,1,1,REASON_COST+REASON_DISCARD,nil)  
end  
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)  
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then  
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)  
	end  
end  
function cm.negop(e,tp,eg,ep,ev,re,r,rp)  
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then  
		Duel.Destroy(eg,REASON_EFFECT)  
	end  
end  