--极左宣言
function c10113004.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10113004+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(TIMING_STANDBY_PHASE)
	e1:SetTarget(c10113004.target)
	e1:SetCondition(c10113004.con)
	e1:SetOperation(c10113004.activate)
	c:RegisterEffect(e1)
	if c10113004.global_effect==nil then
		c10113004.global_effect=true
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e1:SetCode(EVENT_ATTACK_ANNOUNCE)
		e1:SetOperation(c10113005.addcount)
		Duel.RegisterEffect(e1,0)
	end
end

function c10113004.con(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetCurrentPhase()==PHASE_STANDBY 
end

function c10113004.addcount(e,tp,eg,ep,ev,re,r,rp)
	local c=eg:GetFirst()
	local dtp=Duel.GetTurnPlayer()
	if c:GetControler()==dtp then 
	Duel.RegisterFlagEffect(dtp,10113004,RESET_PHASE+PHASE_END,0,1)
	end
end

function c10113004.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsHasType(EFFECT_TYPE_ACTIVATE) end
end
function c10113004.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetCondition(c10113004.effectcon)
	e1:SetOperation(c10113004.effectop)
	Duel.RegisterEffect(e1,tp)
end

function c10113004.effectcon(e,tp,eg,ep,ev,re,r,rp)
	local dtp=Duel.GetTurnPlayer()
	return Duel.GetFlagEffect(tp,10113004)<=0
end

function c10113004.effectop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(dtp,1500,REASON_EFFECT) 
end
