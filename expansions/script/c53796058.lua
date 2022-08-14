local m=53796058
local cm=_G["c"..m]
cm.name="收服之鞭"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.filter(c)
	return c:GetCounter(0)>0 and c:IsControlerCanBeChanged(true)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.filter,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,g:GetCount(),0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.filter,tp,0,LOCATION_MZONE,nil)
	Duel.GetControl(g,tp)
end
