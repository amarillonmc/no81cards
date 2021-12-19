local m=15000318
local cm=_G["c"..m]
cm.name="三瞬三分"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,15000318+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e2)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetCondition(cm.reg1con)
		ge1:SetOperation(cm.reg1op)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.reg1con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==1
end
function cm.reg1op(e,tp,eg,ep,ev,re,r,rp)
	--Record Effect
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(15000318)
	e1:SetTargetRange(1,1)
	e1:SetLabelObject(re)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>=3 and Duel.IsPlayerAffectedByEffect(tp,15000318)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local be=Duel.IsPlayerAffectedByEffect(tp,15000318)
	if be then
		local ae=be:GetLabelObject()
		--Record
		local e1=Effect.CreateEffect(e:GetHandler())
		if ae:GetDescription()>0 then
		   e1:SetDescription(ae:GetDescription())
		else
		   e1:SetDescription(aux.Stringid(m,0))
		end
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e1:SetRange(LOCATION_SZONE)
		e1:SetCountLimit(1)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		if ae:GetProperty() then e1:SetProperty(ae:GetProperty()) end
		if ae:GetCondition() then e1:SetCondition(ae:GetCondition()) end
		if ae:GetTarget() then e1:SetTarget(ae:GetTarget()) end
		if ae:GetOperation() then e1:SetOperation(ae:GetOperation()) end
		e:GetHandler():RegisterEffect(e1)
	end
	--SendtoGrave
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetOperation(cm.sgop)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e2)
end
function cm.sgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_RULE)
end