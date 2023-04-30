local m=82209010
local cm=_G["c"..m]
function cm.initial_effect(c)
	--splimit  
	local e0=Effect.CreateEffect(c)  
	e0:SetType(EFFECT_TYPE_SINGLE)  
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)  
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)  
	e0:SetValue(cm.splimit)  
	c:RegisterEffect(e0)  
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_DISABLE)  
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetHintTiming(TIMINGS_CHECK_MONSTER)  
	e1:SetCountLimit(1,m)  
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)  
	e1:SetOperation(cm.operation)  
	c:RegisterEffect(e1)  
end  
function cm.splimit(e,se,sp,st)  
	return se:IsHasType(EFFECT_TYPE_ACTIONS)  
end  
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()  
	if chk==0 then return c:IsDiscardable() end  
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)  
end  
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end 
end  
function cm.operation(e,tp,eg,ep,ev,re,r,rp)  
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
	if rp==tp or not (re:IsActiveType(TYPE_MONSTER) and re:GetActivateLocation()==LOCATION_MZONE) then return end
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+0x1fc0000+RESET_CHAIN,0,1)  
end  
function cm.deckcon(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	return c:GetFlagEffect(m)~=0
end  
function cm.deckop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	local tc=re:GetHandler()
	local g=Group.CreateGroup()
	g:AddCard(tc)
	Duel.Hint(HINT_CARD,0,m)
	Duel.HintSelection(g)
	if tc and tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() then
		local e2=Effect.CreateEffect(c)  
		e2:SetType(EFFECT_TYPE_SINGLE)  
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
		e2:SetCode(EFFECT_DISABLE)  
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END, 2)  
		tc:RegisterEffect(e2)  
		local e3=Effect.CreateEffect(c)  
		e3:SetType(EFFECT_TYPE_SINGLE)  
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
		e3:SetCode(EFFECT_DISABLE_EFFECT)  
		e3:SetValue(RESET_TURN_SET)  
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END, 2)  
		tc:RegisterEffect(e3) 
	end
end   