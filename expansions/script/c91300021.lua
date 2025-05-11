--魔弓的迎击
function c91300021.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c91300021.stcon)
	e1:SetTarget(c91300021.sttg)
	e1:SetOperation(c91300021.stop)
	c:RegisterEffect(e1)
	if not c91300021.global_check then
		c91300021.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ge2:SetCode(EVENT_CHAIN_SOLVED)
		ge2:SetCondition(c91300021.ndcon)
		ge2:SetOperation(c91300021.ndop)
		Duel.RegisterEffect(ge2,0)
		local ge3=ge2:Clone()
		Duel.RegisterEffect(ge3,1)
	end
end
function c91300021.stcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and not Duel.CheckPhaseActivity()
end
function c91300021.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
end
function c91300021.stop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(tp,PHASE_END,RESET_PHASE+PHASE_END,1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_SKIP_TURN)
	e2:SetTargetRange(0,1)
	e2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e2,tp)
	Duel.SkipPhase(tp,PHASE_DRAW,RESET_PHASE+PHASE_END,2)
	Duel.SkipPhase(tp,PHASE_STANDBY,RESET_PHASE+PHASE_END,2)
	Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetTargetRange(1,1)
	e3:SetValue(aux.TRUE)
	e3:SetReset(RESET_PHASE+PHASE_BATTLE)
	Duel.RegisterEffect(e3,tp)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_EP)
	e4:SetTargetRange(1,0)
	e4:SetReset(RESET_PHASE+PHASE_MAIN2+RESET_SELF_TURN)
	Duel.RegisterEffect(e4,tp)
	Duel.RegisterFlagEffect(tp,91300021,RESET_PHASE+PHASE_BATTLE,0,1)
	--Debug.Message(Duel.GetFlagEffect(tp,91300021))
end
function c91300021.ndcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,91300021)~=0
end
function c91300021.ndop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE) 
	e1:SetOperation(c91300021.thop)
	e1:SetReset(RESET_PHASE+PHASE_MAIN1+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)
end
function c91300021.thop(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	if ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE then
		Duel.SkipPhase(tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE_STEP,1)
	end
end