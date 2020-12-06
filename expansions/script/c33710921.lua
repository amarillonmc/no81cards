--破防
function c33710921.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c33710921.con)
	e1:SetOperation(c33710921.activate)
	c:RegisterEffect(e1)
	if c33710921.counter==nil then
		c33710921.counter=true
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetCode(EVENT_DESTROYED)
		e2:SetOperation(c33710921.addcount)
		Duel.RegisterEffect(e2,0)
	end
end
function c33710921.addcount(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(Card.IsReason,nil,REASON_BATTLE)
	local tc=g:GetFirst()
	while tc do
		Duel.RegisterFlagEffect(tc:GetPreviousControler(),33710921,RESET_PHASE+PHASE_END,0,1)
		tc=g:GetNext()
	end
end
function c33710921.con(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return  ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c33710921.activate(e,tp,eg,ep,ev,re,r,rp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e2:SetOperation(c33710921.dop)
	e2:SetReset(RESET_PHASE+PHASE_END,1)
	Duel.RegisterEffect(e2,tp)
end
function c33710921.dop(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp and Duel.GetFlagEffect(1-tp,33710921)>=6 then
		Duel.ChangeBattleDamage(ep,13370)
		e:Reset()
	end
end