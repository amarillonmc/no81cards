--Last Shooting
function c33700927.initial_effect(c)
	 --activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetHintTiming(TIMING_BATTLE_END)
	e1:SetCondition(c33700927.condition)
	e1:SetTarget(c33700927.target)
	e1:SetOperation(c33700927.activate)
	c:RegisterEffect(e1) 
	if c33700927.counter==nil then
		c33700927.counter=true
		c33700927[0]=0
		c33700927[1]=0
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e2:SetOperation(c33700927.resetcount)
		Duel.RegisterEffect(e2,0)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3:SetCode(EVENT_BATTLE_DAMAGE)
		e3:SetOperation(c33700927.addcount)
		Duel.RegisterEffect(e3,0)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e4:SetCode(EVENT_ATTACK_ANNOUNCE)
		e4:SetOperation(c33700927.addcount2)
		Duel.RegisterEffect(e4,0)
	end  
end
function c33700927.resetcount(e,tp,eg,ep,ev,re,r,rp)
	c33700927[0]=0
	c33700927[1]=0
end
function c33700927.addcount(e,tp,eg,ep,ev,re,r,rp)
	c33700927[rp]=c33700927[rp]+ev
end
function c33700927.addcount2(e,tp,eg,ep,ev,re,r,rp)
	local ac=eg:GetFirst()
	if ac:IsRace(RACE_MACHINE) then
		Duel.RegisterFlagEffect(ac:GetControler(),33700927,RESET_PHASE+PHASE_END,0,1)
	end
end
function c33700927.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_BATTLE and Duel.GetTurnPlayer()==tp and c33700927[tp]>=4000 and Duel.GetLP(1-tp)<=1000
end
function c33700927.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(2100)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,2100)
	if Duel.GetFlagEffect(tp,33700927)>0 then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function c33700927.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
