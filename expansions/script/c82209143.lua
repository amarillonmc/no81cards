--堕天使的
local m=82209143
local cm=c82209143
function cm.initial_effect(c)  
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_REMOVE)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)  
	e1:SetCost(cm.cost)  
	e1:SetTarget(cm.target)  
	e1:SetOperation(cm.activate)  
	c:RegisterEffect(e1)  
end  
function cm.costfilter(c)  
	return c:IsSetCard(0xef)  
		and c:IsType(TYPE_MONSTER) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsAbleToGraveAsCost()	
end  
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)  
	local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)  
	Duel.SendtoGrave(g,REASON_COST)  
end  
function cm.rmfilter(c)
	return c:IsAbleToRemove(tp,POS_FACEDOWN)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	local g=Duel.GetMatchingGroup(cm.rmfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)  
	if chk==0 then return g:GetCount()>0 end  
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)  
end  
function cm.activate(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)  
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.rmfilter),tp,LOCATION_GRAVE,LOCATION_GRAVE,1,3,nil)  
	if g:GetCount()>0 then  
		Duel.HintSelection(g)  
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)  
	end  
end  