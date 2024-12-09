--再见绘梨
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--time 999
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(s.tiop)
	c:RegisterEffect(e2)
	--time 30
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)  
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCondition(s.ticon)
	e3:SetOperation(s.tiop1)
	c:RegisterEffect(e3)
	--time reset
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)  
	e4:SetCode(EVENT_LEAVE_FIELD_P)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetCondition(s.ticon3)
	e4:SetOperation(s.tiop3)
	c:RegisterEffect(e4)
end
function s.tiop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ResetTimeLimit(tp,999)
	Duel.ResetTimeLimit(1-tp,999)
end
function s.ticon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_SZONE) and c:IsPreviousPosition(POS_FACEUP)
end
function s.tiop1(e,tp,eg,ep,ev,re,r,rp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetLabel(rp)
	e2:SetOperation(s.tiop2)
	Duel.RegisterEffect(e2,tp)
end
function s.tiop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.ResetTimeLimit(e:GetLabel(),30)
end
function s.ticon3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsReason(REASON_DESTROY)
end
function s.tiop3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsLocation(LOCATION_SZONE) then return end
	Duel.ResetTimeLimit(tp,240)
	Duel.ResetTimeLimit(1-tp,240)
end