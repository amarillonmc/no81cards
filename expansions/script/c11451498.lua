--年轮守时者
--21.04.10
local m=11451498
local cm=_G["c"..m]
function cm.initial_effect(c)
	--effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.redcon)
	e1:SetCost(cm.redcost)
	e1:SetOperation(cm.redop)
	c:RegisterEffect(e1)
end
function cm.redcon(e,tp,eg,ep,ev,re,r,rp)
	return true
end
function cm.redcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function cm.redop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local num=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetLabel(num)
	e1:SetOperation(cm.adjustop)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
end
function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	local num=e:GetLabel()
	local n1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)-num
	local n2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)-num
	if n1>0 then n1=Duel.DiscardHand(tp,Card.IsDiscardable,n1,n1,REASON_RULE+REASON_DISCARD,nil) end
	if n2>0 then n2=Duel.DiscardHand(1-tp,Card.IsDiscardable,n2,n2,REASON_RULE+REASON_DISCARD,nil) end
	if n1>0 or n2>0 then Duel.Readjust() end
end