local m=82208101
local cm=_G["c"..m]
cm.name="各自为战"
function cm.initial_effect(c)  
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.cost) 
	e1:SetOperation(cm.activate)  
	c:RegisterEffect(e1)
	--act in hand  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_SINGLE)  
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)  
	c:RegisterEffect(e2)  
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.CheckLPCost(tp,4000) end  
	Duel.PayLPCost(tp,4000)  
end  
function cm.activate(e,tp,eg,ep,ev,re,r,rp) 
	local e1=Effect.CreateEffect(e:GetHandler())  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_IMMUNE_EFFECT)  
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e1:SetTarget(cm.immtg)  
	e1:SetValue(cm.efilter)  
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,3)
	Duel.RegisterEffect(e1,tp) 
end
function cm.immtg(e,c) 
	return true
end  
function cm.efilter(e,te,c)  
	return te:GetOwner()~=c
end  
