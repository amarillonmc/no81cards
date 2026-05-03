--Lost Desire
function c87531035.initial_effect(c)
	--activate limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_DRAW_PHASE)
	e1:SetTarget(c87531035.target)
	e1:SetOperation(c87531035.operation)
	c:RegisterEffect(e1)
end
function c87531035.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,87531035)==0 end
end
function c87531035.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,1)
	e1:SetValue(c87531035.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,87531035,RESET_PHASE+PHASE_END,0,0)
end
function c87531035.aclimit(e,re,tp)
	return (re:GetActivateLocation()==LOCATION_GRAVE or re:GetActivateLocation()==LOCATION_REMOVED) and re:IsActiveType(TYPE_MONSTER)
end
