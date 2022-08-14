local m=53796046
local cm=_G["c"..m]
cm.name="奇点背离"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.cfilter(c)
	return c:IsFaceup() and c:GetSequence()>4
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(cm.cfilter,tp,0,LOCATION_MZONE,1,nil)
end
function cm.desfilter(c)
	return c:GetSequence()<5
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(cm.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(cm.chainlm)
	end
end
function cm.chainlm(e,rp,tp)
	local c=e:GetHandler()
	return not (c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
