local m=82228627
local cm=_G["c"..m]
cm.name="孑影之刍形"
function cm.initial_effect(c)
	--pos  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_POSITION)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)  
	e1:SetCondition(cm.condition)  
	e1:SetCost(cm.cost)  
	e1:SetTarget(cm.target)  
	e1:SetOperation(cm.operation)  
	c:RegisterEffect(e1)  
end  
function cm.condition(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.GetAttacker():IsControler(1-tp)  
end  
function cm.costfilter(c)  
	return c:IsSetCard(0x3299) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()  
end  
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_HAND,0,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)  
	local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_HAND,0,1,1,nil)  
	Duel.SendtoGrave(g,REASON_COST)  
end  
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then  
		local at=Duel.GetAttacker()  
		return at:IsAttackPos() and at:IsCanChangePosition()  
	end  
end  
function cm.operation(e,tp,eg,ep,ev,re,r,rp)  
	local at=Duel.GetAttacker()  
	if at:IsAttackPos() and at:IsRelateToBattle() then  
		Duel.ChangePosition(at,POS_FACEUP_DEFENSE)  
	end  
end
