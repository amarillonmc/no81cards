local m=82228637
local cm=_G["c"..m]
cm.name="摸头"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)   
	e1:SetType(EFFECT_TYPE_QUICK_O)  
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetHintTiming(TIMING_DRAW_PHASE)
	e1:SetCountLimit(1,m)
	e1:SetCost(aux.bfgcost) 
	e1:SetOperation(cm.op)  
	c:RegisterEffect(e1)  
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
	e2:SetCode(EVENT_CHAINING)
	e2:SetReset(RESET_PHASE+PHASE_END) 
	e2:SetOperation(cm.regop)  
	Duel.RegisterEffect(e2,tp)  
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
	e3:SetCode(EVENT_CHAIN_SOLVED)  
	e3:SetReset(RESET_PHASE+PHASE_END) 
	e3:SetCondition(cm.deckcon)  
	e3:SetOperation(cm.deckop)  
	Duel.RegisterEffect(e3,tp)  
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)   
	if rp==tp then return end
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+0x1fc0000+RESET_CHAIN,0,1)  
end  
function cm.deckcon(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	return c:GetFlagEffect(m)~=0
end  
function cm.deckop(e,tp,eg,ep,ev,re,r,rp)  
	local p=1-tp
	Duel.Hint(HINT_CARD,0,m)  
	local ct=16
	if Duel.GetFieldGroupCount(p,0,LOCATION_DECK)<16 then
		ct=Duel.GetFieldGroupCount(p,0,LOCATION_DECK)
	end
	Duel.SortDecktop(p,p,ct)  
	for i=1,ct do  
		local mg=Duel.GetDecktopGroup(p,1)  
		Duel.MoveSequence(mg:GetFirst(),1)  
	end  
end  