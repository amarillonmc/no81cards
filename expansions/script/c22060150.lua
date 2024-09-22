--异天枝-卡麦尔
function c22060150.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22060150,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,22060150)
	e1:SetCost(c22060150.cost)
	e1:SetOperation(c22060150.operation)
	c:RegisterEffect(e1)
end
function c22060150.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c22060150.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c22060150.drcon1)
	e1:SetOperation(c22060150.drop1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)

	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CHANGE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetValue(c22060150.damval)
	e2:SetCondition(c22060150.condition)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c22060150.drcon1(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function c22060150.drop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(tp,500,REASON_EFFECT,true)
	Duel.Damage(1-tp,500,REASON_EFFECT,true)
	Duel.RDComplete()
end
function c22060150.condition(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return Duel.GetLP(tp)<Duel.GetLP(1-tp)
end
function c22060150.damval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then return 0
	else return val end
end