--械忍 伊贺
local m=82209117
local cm=_G["c"..m]
function cm.initial_effect(c)
	 --negate  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_DISABLE)  
	e1:SetType(EFFECT_TYPE_QUICK_O)  
	e1:SetCode(EVENT_CHAINING)  
	e1:SetRange(LOCATION_HAND)  
	e1:SetCountLimit(1,m)  
	e1:SetCondition(cm.discon)  
	e1:SetCost(cm.discost)  
	e1:SetTarget(cm.distg)  
	e1:SetOperation(cm.disop)  
	c:RegisterEffect(e1)  
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)  
	return re:IsActiveType(TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainDisablable(ev)  
end  
function cm.discost(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()  
	if chk==0 then return c:IsDiscardable() end  
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)  
end  
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return not re:GetHandler():IsStatus(STATUS_DISABLED) end  
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)  
end  
function cm.disop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.NegateEffect(ev)  
end  