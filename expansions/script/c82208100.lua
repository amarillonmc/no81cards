local m=82208100
local cm=_G["c"..m]
cm.name="闭关锁国"
function cm.initial_effect(c)  
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)	
	e1:SetOperation(cm.activate)  
	c:RegisterEffect(e1)
	--act in hand  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_SINGLE)  
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)  
	c:RegisterEffect(e2)  
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp) 
	local e1=Effect.CreateEffect(e:GetHandler())  
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e1:SetCode(1040)
	e1:SetCondition(cm.lpcon)
	e1:SetOperation(cm.lpop) 
	Duel.RegisterEffect(e1,tp)  
end
function cm.lpcon(e,tp,eg,ep,ev,re,r,rp) 
	return Duel.GetLP(tp)~=8000 or Duel.GetLP(1-tp)~=8000
end
function cm.lpop(e,tp,eg,ep,ev,re,r,rp) 
	Duel.Hint(HINT_CARD,0,m)
	if Duel.GetLP(tp)~=8000 then
		Duel.SetLP(tp,8000)
	end
	if Duel.GetLP(1-tp)~=8000 then
		Duel.SetLP(1-tp,8000)
	end
end
