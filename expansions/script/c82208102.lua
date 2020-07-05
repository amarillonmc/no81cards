local m=82208102
local cm=_G["c"..m]
cm.name="宇宙膨胀"
function cm.initial_effect(c)
	c:EnableCounterPermit(0x298)  
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	c:RegisterEffect(e1)
	--add counter  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
	e2:SetProperty(EFFECT_FLAG_DELAY)  
	e2:SetRange(LOCATION_SZONE)  
	e2:SetCode(EVENT_MOVE)  
	e2:SetOperation(cm.ctop)  
	c:RegisterEffect(e2)  
	--act in hand  
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_SINGLE)  
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)  
	e3:SetCondition(cm.handcon)  
	c:RegisterEffect(e3) 
	--destroy replace  
	local e4=Effect.CreateEffect(c)  
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)  
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)  
	e4:SetCode(EFFECT_DESTROY_REPLACE)  
	e4:SetRange(LOCATION_SZONE)  
	e4:SetTarget(cm.reptg)  
	e4:SetOperation(cm.repop)  
	c:RegisterEffect(e4)  
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)  
	local ct1=e:GetHandler():GetCounter(0x298)
	if e:GetHandler():AddCounter(0x298,(ct1+1))~=0 then
		Duel.BreakEffect()
		local ct2=Duel.GetCounter(tp,1,0,0x298)
		Duel.Recover(tp,ct2*100,REASON_EFFECT)
	end
end  
function cm.handcon(e)  
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_ONFIELD,0)==0  
end  
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()  
	if chk==0 then return c:GetCounter(0x298)>0 end  
	return Duel.SelectEffectYesNo(tp,c,96)  
end  
function cm.repop(e,tp,eg,ep,ev,re,r,rp)  
	e:GetHandler():RemoveCounter(ep,0x298,1,REASON_EFFECT)  
end  