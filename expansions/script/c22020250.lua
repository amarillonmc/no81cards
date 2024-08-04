--人理之诗 炽天覆七重圆环
function c22020250.initial_effect(c)
	aux.AddCodeList(c,22020220,22020230)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22020250,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_BATTLE_START+TIMING_BATTLE_END)
	e1:SetCountLimit(1,22020250+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c22020250.condition)
	e1:SetOperation(c22020250.activate)
	c:RegisterEffect(e1)
	--boost
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsCode,22020220))
	e2:SetValue(1)
	e2:SetCondition(c22020250.condition)
	c:RegisterEffect(e2)
end
function c22020250.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
end
function c22020250.activate(e,tp,eg,ep,ev,re,r,rp)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_ATTACK_ANNOUNCE)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetCondition(c22020250.discon)
		e1:SetOperation(c22020250.disop)
		Duel.RegisterEffect(e1,tp)
end
function c22020250.discon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(22020250)<=6
end
function c22020250.disop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(22020250,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(HINT_CARD,0,22020250)
	Duel.NegateAttack()
end
function c22020250.cfilter(c)
	return c:IsFaceup() and c:IsCode(22020230)
end
function c22020250.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22020250.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end