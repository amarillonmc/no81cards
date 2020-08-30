local m=82207006
local cm=_G["c"..m]
function cm.initial_effect(c)  
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_REMOVE)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetCondition(cm.condition)  
	e1:SetTarget(cm.target)  
	e1:SetOperation(cm.activate)  
	c:RegisterEffect(e1)  
end  
function cm.condition(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)  
end  
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)-Duel.GetFieldGroupCount(tp,0,LOCATION_DECK) 
	local g=Duel.GetDecktopGroup(tp,ct)
	local sg=g:GetFirst()
	if not sg:IsAbleToRemove() then return false end
	for i=1,ct-1 do
		sg=g:GetNext()
		if not sg:IsAbleToRemove() then return false end
	end   
	if chk==0 then return ct>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,ct,tp,LOCATION_DECK)  
end  
function cm.activate(e,tp,eg,ep,ev,re,r,rp)  
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)-Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
	local g=nil
	if ct>0 then  
		g=Duel.GetDecktopGroup(tp,ct)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)  
	end  
end  