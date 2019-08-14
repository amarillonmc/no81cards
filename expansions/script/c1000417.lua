--魔法决战！
function c1000417.initial_effect(c)
	c:SetUniqueOnField(1,1,1000417)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c1000417.cost)
	e1:SetOperation(c1000417.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c1000417.handcon)
	c:RegisterEffect(e2)
	--activate limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetOperation(c1000417.aclimit1)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_CHAIN_NEGATED)
	e4:SetRange(LOCATION_SZONE)
	e4:SetOperation(c1000417.aclimit2)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_ACTIVATE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(0,1)
	e5:SetCondition(c1000417.econ)
	e5:SetValue(c1000417.elimit)
	c:RegisterEffect(e5)
end
function c1000417.filter1(c)
	return c:IsType(TYPE_CONTINUOUS) and c:IsFaceup() and c:IsAbleToGrave() and not c:IsCode(1000417)
end
function c1000417.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1000417.filter1,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil,e,tp) end
	local g=Duel.GetMatchingGroup(c1000417.filter1,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c1000417.activate(e,tp,eg,ep,ev,re,r,rp)
	--destroy
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	if Duel.GetCurrentPhase()==PHASE_STANDBY and Duel.GetTurnPlayer()==tp then
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
	else
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
	end
	if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_DRAW then
		e1:SetLabel(0)
	else
		e1:SetLabel(Duel.GetTurnCount())
	end
	e1:SetCondition(c1000417.descon)
	e1:SetOperation(c1000417.desop)
	Duel.RegisterEffect(e1,tp)
end
function c1000417.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetTurnCount()~=e:GetLabel()
end
function c1000417.desop(e,tp,eg,ep,ev,re,r,rp)
   local c=e:GetHandler()
   Duel.Destroy(c,REASON_RULE)
end
function c1000417.cfilter(c)
	return c:IsCode(1000406) and c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c1000417.handcon(e)
	local g=Duel.GetFieldGroup(e:GetHandlerPlayer(),LOCATION_MZONE,0)
	return g:IsExists(c1000417.cfilter,1,nil)
end
function c1000417.aclimit1(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	e:GetHandler():RegisterFlagEffect(1000417,RESET_EVENT+0x3ff0000+RESET_PHASE+PHASE_END,0,1)
end
function c1000417.aclimit2(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	e:GetHandler():ResetFlagEffect(1000417)
end
function c1000417.econ(e)
	return e:GetHandler():GetFlagEffect(1000417)~=0
end
function c1000417.elimit(e,te,tp)
	return te:IsHasType(EFFECT_TYPE_ACTIVATE)
end