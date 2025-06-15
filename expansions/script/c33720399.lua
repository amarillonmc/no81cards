--[[
圆满之殇
Wound of Perfection
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
Duel.LoadScript("glitchylib_vsnemo.lua")
Duel.LoadScript("glitchylib_lprecover.lua")
function s.initial_effect(c)
	--[[Apply the following effects for the rest of the Duel.
	● During each Standby Phase, if your LP is lower than your opponent, gain 6000 LP.
	● If your LP decreases (either from taking damage, paying LP or losing LP from a card effect) while your LP was higher than your opponent's, your LP becomes 0.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetFunctions(
		nil,
		nil,
		s.target,
		s.activate
	)
	c:RegisterEffect(e1)
end

--E1
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id)==0 end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,id,0,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,1))
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:Desc(2,id)
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE|PHASE_STANDBY)
	e1:OPT()
	e1:SetFunctions(s.rccon,nil,nil,s.rcop)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetCondition(s.regcon)
	e2:SetOperation(s.regop)
	Duel.RegisterEffect(e2,tp)
	local e2b=e2:Clone()
	e2b:SetCode(EVENT_PAY_LPCOST)
	e2b:SetOperation(s.regop)
	Duel.RegisterEffect(e2b,tp)
	local e2c=e2:Clone()
	e2c:SetCode(EVENT_LP_CHANGE)
	e2c:SetCondition(s.regcon)
	e2c:SetOperation(s.regop)
	Duel.RegisterEffect(e2c,tp)
end
function s.rccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<Duel.GetLP(1-tp)
end
function s.rcop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,id)
	Duel.Recover(tp,6000,REASON_EFFECT)
end

function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and (e:GetCode()~=EVENT_LP_CHANGE or ev<0) and Duel.GetLP(tp)+ev>Duel.GetLP(1-tp)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,id)
	Duel.SetLP(tp,0,LP_REASON_BECOME,tp)
end