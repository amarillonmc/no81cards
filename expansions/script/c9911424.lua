--律魔王『世界法则』
function c9911424.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c9911424.spcon)
	e1:SetOperation(c9911424.spop)
	c:RegisterEffect(e1)
	--effect gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,9911424)
	e2:SetOperation(c9911424.efop)
	c:RegisterEffect(e2)
end
function c9911424.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.CheckLPCost(tp,2000)
end
function c9911424.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.PayLPCost(tp,2000)
end
function c9911424.effilter(c,tp)
	return c:IsType(TYPE_EFFECT) and c:IsFaceup() and c:GetReasonPlayer()==tp
end
function c9911424.efop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9911424.effilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil,1-tp)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(tc)
		e1:SetDescription(aux.Stringid(9911424,0))
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetRange(LOCATION_REMOVED)
		e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e1:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_ILLUSION))
		e1:SetValue(c9911424.atkval)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(tc)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_ACTIVATE_COST)
		e2:SetRange(LOCATION_REMOVED)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e2:SetTargetRange(1,0)
		e2:SetCondition(c9911424.costcon1)
		e2:SetCost(c9911424.costchk)
		e2:SetOperation(c9911424.costop)
		tc:RegisterEffect(e2)
		local e3=e2:Clone()
		e3:SetTargetRange(0,1)
		e3:SetCondition(c9911424.costcon2)
		tc:RegisterEffect(e3)
		local e4=Effect.CreateEffect(tc)
		e4:SetType(EFFECT_TYPE_FIELD)
		e4:SetCode(EFFECT_FLAG_EFFECT+9911424)
		e4:SetRange(LOCATION_REMOVED)
		e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e4:SetTargetRange(1,1)
		tc:RegisterEffect(e4)
		tc=g:GetNext()
	end
end
function c9911424.atkval(e,c)
	return Duel.GetFieldGroupCount(0,LOCATION_REMOVED,LOCATION_REMOVED)*100
end
function c9911424.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_ILLUSION)
end
function c9911424.costcon1(e)
	return Duel.IsExistingMatchingCard(c9911424.cfilter,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
end
function c9911424.costcon2(e)
	return Duel.IsExistingMatchingCard(c9911424.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c9911424.costchk(e,te_or_c,tp)
	local ct=2*Duel.GetFlagEffect(tp,9911424)
	local g=Duel.GetDecktopGroup(tp,ct)
	return g:FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)==ct
end
function c9911424.costop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(tp,2)
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
