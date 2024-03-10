--次元崩塌
local m=16670004
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(cm.cfilter,tp,LOCATION_EXTRA,0,nil)>Duel.GetMatchingGroupCount(cm.cfilter2,tp,0,LOCATION_EXTRA,nil)
end
function cm.cfilter(c)
	return c:IsFacedown() and c:IsAbleToGrave()
end
function cm.cfilter2(c)
	return c:IsFacedown()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(cm.cfilter,tp,LOCATION_EXTRA,0,nil)-Duel.GetMatchingGroupCount(cm.cfilter2,tp,0,LOCATION_EXTRA,nil)
	local g1=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_EXTRA,0,nil)
    local t=g1:GetFirst()
	local p=Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)
	while t do
		if not (t:IsFacedown() or t:IsAbleToGrave()) then
			p=p-1
		end
		t=g1:GetNext()
	end
	if chk==0 then return ct>0 and p>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,tp,ct)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(cm.cfilter,tp,LOCATION_EXTRA,0,nil)-Duel.GetMatchingGroupCount(cm.cfilter2,tp,0,LOCATION_EXTRA,nil)
	local g1=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_EXTRA,0,nil)
	local t=g1:GetFirst()
	local p=Group.CreateGroup()
	while t do
		if t:IsFacedown() and t:IsAbleToGrave() then
			p:AddCard(t)
		end
		t=g1:GetNext()
	end
	if ct>0 and p:GetCount()>0 then
		local dg=p:RandomSelect(tp,ct)
		Duel.SendtoGrave(dg,REASON_EFFECT)
	end
end