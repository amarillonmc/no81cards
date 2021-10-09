--咕噜~咕噜~咕噜灵波！
function c9950623.initial_effect(c)
	 --damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_PLAYER_TARGET)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCountLimit(1,9950623+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c9950623.cost)
	e1:SetTarget(c9950623.damtg)
	e1:SetOperation(c9950623.damop)
	c:RegisterEffect(e1)
end
function c9950623.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c9950623.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(c9950623.chlimit)
	end
end
function c9950623.chlimit(e,ep,tp)
	return tp==ep
end
function c9950623.damop(e,tp,eg,ep,ev,re,r,rp)
	 local c=e:GetHandler()
	 local e1=Effect.CreateEffect(c)
	 e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	 e1:SetCode(EVENT_TO_HAND)
	 e1:SetProperty(EFFECT_FLAG_DELAY)
	 if Duel.GetTurnPlayer()==tp then
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
	 else
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN)
	 end
	e1:SetCondition(c9950623.damcon1)
	e1:SetOperation(c9950623.damop1)
	Duel.RegisterEffect(e1,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_TO_HAND)
	if Duel.GetTurnPlayer()==tp then
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
	 else
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN)
	 end
	e3:SetCondition(c9950623.regcon)
	e3:SetOperation(c9950623.regop)
	c:RegisterEffect(e3,tp)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_CHAIN_SOLVED)
	 if Duel.GetTurnPlayer()==tp then
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
	 else
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN)
	 end
	e4:SetCondition(c9950623.damcon2)
	e4:SetOperation(c9950623.damop2)
	c:RegisterEffect(e4,tp)
	if not c9950623.global_check then
		c9950623.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVING)
		ge1:SetOperation(c9950623.count)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAIN_SOLVED)
		ge2:SetOperation(c9950623.reset)
		Duel.RegisterEffect(ge2,0)
	end
end
function c9950623.count(e,tp,eg,ep,ev,re,r,rp)
	c9950623.chain_solving=true
end
function c9950623.reset(e,tp,eg,ep,ev,re,r,rp)
	c9950623.chain_solving=false
end
function c9950623.damcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsControler,1,nil,1-tp) and not c9950623.chain_solving
end
function c9950623.damop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,9950623)
	local ct=eg:FilterCount(Card.IsControler,nil,1-tp)
	Duel.Damage(1-tp,ct*500,REASON_EFFECT)
end
function c9950623.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsControler,1,nil,1-tp) and c9950623.chain_solving
end
function c9950623.regop(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(Card.IsControler,nil,1-tp)
	e:GetHandler():RegisterFlagEffect(35199657,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1,ct)
end
function c9950623.damcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(35199657)>0
end
function c9950623.damop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,9950623)
	local labels={e:GetHandler():GetFlagEffectLabel(35199657)}
	local ct=0
	for i=1,#labels do ct=ct+labels[i] end
	e:GetHandler():ResetFlagEffect(35199657)
	Duel.Damage(1-tp,ct*500,REASON_EFFECT)
end
