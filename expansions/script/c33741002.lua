--冀散华·奇迹的重圆
local s,id,o=GetID()
s.ct={[0]=0,[1]=0}
s.mct={[0]=0,[1]=0}
s.sct={[0]=0,[1]=0}
s.tct={[0]=0,[1]=0}
function s.initial_effect(c)
	--Activate from hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(s.handcon)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(s.chainop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(s.resetop)
		Duel.RegisterEffect(ge2,0)
	end
end
function s.chainop(e,tp,eg,ep,ev,re,r,rp)
	if rp~=0 and rp~=1 then return end
	s.ct[rp]=s.ct[rp]+1
	if re:IsActiveType(TYPE_MONSTER) then
		s.mct[rp]=s.mct[rp]+1
	end
	if re:IsActiveType(TYPE_SPELL) then
		s.sct[rp]=s.sct[rp]+1
	end
	if re:IsActiveType(TYPE_TRAP) then
		s.tct[rp]=s.tct[rp]+1
	end
end
function s.resetop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetTurnPlayer()
	s.ct[p]=0
	s.mct[p]=0
	s.sct[p]=0
	s.tct[p]=0
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local p=1-tp
	return s.mct[p]>0 and s.sct[p]>0 and s.tct[p]>0
end
function s.handcon(e)
	local tp=e:GetHandlerPlayer()
	return s.condition(e,tp,nil,0,0,nil,0,0)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return s.condition(e,tp,eg,ep,ev,re,r,rp) end
	e:SetLabel(s.ct[1-tp])
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	if ct>=7 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CHANGE_DAMAGE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetValue(0)
		e1:SetReset(RESET_PHASE+PHASE_END,4)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
		Duel.RegisterEffect(e2,tp)
	end
	if ct>=13 then
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_CANNOT_ACTIVATE)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetTargetRange(0,1)
		e3:SetValue(s.aclimit)
		e3:SetLabel(tp)
		e3:SetReset(RESET_PHASE+PHASE_END,4)
		Duel.RegisterEffect(e3,tp)
		local e4=e3:Clone()
		e4:SetValue(s.battlelimit)
		Duel.RegisterEffect(e4,tp)
	end
end
function s.aclimit(e,re,tp)
	local ct=Duel.GetCurrentChain()
	if ct==0 then return false end
	local p=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_PLAYER)
	return p==e:GetLabel()
end
function s.battlelimit(e,re,tp)
	local p=e:GetLabel()
	local ph=Duel.GetCurrentPhase()
	if ph~=PHASE_DAMAGE and ph~=PHASE_DAMAGE_CAL then return false end
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return (a and a:IsControler(p)) or (d and d:IsControler(p))
end
