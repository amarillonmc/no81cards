--小马除错方略
--Scripted by: XGlitchy30
local id=33720021
local s=_G["c"..tostring(id)]
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--count
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BATTLE_DAMAGE)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
--count
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if ev<=0 then return end
	if Duel.GetFlagEffect(ep,id)<=0 then
		Duel.RegisterFlagEffect(ep,id,RESET_PHASE+PHASE_END,0,1)
	end
	Duel.SetFlagEffectLabel(ep,id,Duel.GetFlagEffectLabel(ep,id)+ev)
end
--Activate
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN2 and Duel.GetTurnPlayer()==tp
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(1-tp,id)>0 end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=(Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_STANDBY) and 2 or 1
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetCondition(s.damcon)
	e1:SetOperation(s.damop)
	e1:SetLabel(ct-1,Duel.GetFlagEffectLabel(1-tp,id))
	e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,ct)
	Duel.RegisterEffect(e1,tp)
end
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local t,val=e:GetLabel()
	if t==1 then
		e:SetLabel(0)
	else
		Duel.Damage(1-tp,val,REASON_EFFECT)
	end
end
