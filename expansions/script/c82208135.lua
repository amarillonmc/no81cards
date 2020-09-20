local m=82208135
local cm=_G["c"..m]
cm.name="浮世之黯影"
function cm.initial_effect(c)
	--synchro summon  
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)  
	c:EnableReviveLimit() 
	c:SetUniqueOnField(1,0,m)
	local e1=Effect.CreateEffect(c)   
	e1:SetType(EFFECT_TYPE_QUICK_O)  
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetHintTiming(TIMING_DRAW_PHASE)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL)
	e1:SetCost(aux.bfgcost) 
	e1:SetOperation(cm.op)  
	c:RegisterEffect(e1)  
	local e3=e1:Clone()
	e3:SetRange(LOCATION_EXTRA)
	e3:SetCondition(cm.con)
	c:RegisterEffect(e3)
	--atk
	local e2=Effect.CreateEffect(c)  
	e2:SetCategory(CATEGORY_ATKCHANGE)  
	e2:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)  
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)  
	e2:SetCondition(cm.atkcon)  
	e2:SetOperation(cm.atkop)  
	c:RegisterEffect(e2)  
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0  
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
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local bc=c:GetBattleTarget()  
	return bc and bc:IsType(TYPE_SYNCHRO) and bc:IsControler(1-tp)  
end  
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local bc=c:GetBattleTarget()  
	if c:IsRelateToBattle() and c:IsFaceup() and bc:IsFaceup() then  
		local e1=Effect.CreateEffect(c)  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_UPDATE_ATTACK)  
		e1:SetReset(RESET_PHASE+PHASE_END)  
		e1:SetValue(bc:GetAttack())  
		c:RegisterEffect(e1)  
	end  
end  