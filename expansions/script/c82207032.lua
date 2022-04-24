--螺旋阶梯
local m=82207032
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_TOGRAVE)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)   
	e1:SetOperation(cm.activate)  
	c:RegisterEffect(e1)  
	--act in hand  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_SINGLE)  
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)  
	e2:SetCondition(cm.handcon)  
	c:RegisterEffect(e2) 
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())  
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
	e1:SetCode(EVENT_PHASE+PHASE_END)  
	e1:SetCountLimit(1)  
	e1:SetCondition(cm.tgcon)  
	e1:SetOperation(cm.tgop)  
	e1:SetReset(RESET_PHASE+PHASE_END)  
	Duel.RegisterEffect(e1,tp)  
end
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,LOCATION_MZONE,nil)   
	return g:GetCount()>0 
end  
function cm.tgop(e,tp,eg,ep,ev,re,r,rp) 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)  
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,LOCATION_MZONE,nil)  
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		local dg=g:Select(tp,1,1,nil)
		Duel.Hint(HINT_CARD,0,m)
		Duel.HintSelection(dg)  
		Duel.SendtoGrave(dg,REASON_EFFECT)  
	end  
end  
function cm.handcon(e)  
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)==0  
end  