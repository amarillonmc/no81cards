--你休想天使
local s,id,o=GetID()
function s.initial_effect(c)
	--cannot lose
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetOperation(s.clop)
	e1:SetCost(s.clcost)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCondition(s.clcon)
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DAMAGE)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp and bit.band(r,REASON_EFFECT)~=0 or bit.band(r,REASON_BATTLE)~=0 then
		Duel.RegisterFlagEffect(ep,id,RESET_PHASE+PHASE_END,0,1)
	end
end
function s.clcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,12847401)~=0
end
function s.clcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function s.clop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ex1=Effect.CreateEffect(e:GetHandler())
	ex1:SetType(EFFECT_TYPE_FIELD)
	ex1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	ex1:SetCode(EFFECT_CANNOT_LOSE_KOISHI)
	ex1:SetTargetRange(1,0)
	ex1:SetValue(1)
	ex1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(ex1,true,tp)
	return ex1
end