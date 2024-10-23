--圣地友爱团的雷霆一击
local m=64800191
local cm=_G["c"..m]
function cm.initial_effect(c)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.cfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x412) and c:IsType(TYPE_XYZ)
end
function cm.cfilter2(c)
	return c:IsFaceup() and c:IsLevel(10)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.IsExistingMatchingCard(cm.cfilter1,tp,LOCATION_MZONE,0,1,nil) 
	or Duel.IsExistingMatchingCard(cm.cfilter2,tp,LOCATION_MZONE,0,2,nil))
	and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE))
	and Duel.IsChainNegatable(ev)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cm.actcfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x412) and c:IsType(TYPE_XYZ)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)>0
		and Duel.IsExistingMatchingCard(cm.actcfilter,tp,LOCATION_MZONE,0,1,nil,e) and c:IsLocation(LOCATION_ONFIELD)
		and c:IsRelateToEffect(e) and c:IsCanOverlay() and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		local g2=Duel.SelectMatchingCard(tp,cm.actcfilter,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.HintSelection(g2)
		local sc=g2:GetFirst()
		if sc:IsImmuneToEffect(e) then return end
		c:CancelToGrave()
		Duel.Overlay(sc,Group.FromCards(c))
	end
end
