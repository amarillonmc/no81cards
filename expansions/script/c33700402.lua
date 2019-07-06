--End Of A Miracle
function c33700402.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c33700402.condition)
	e1:SetOperation(c33700402.operation)
	c:RegisterEffect(e1)
	--activate from hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c33700402.handcon)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(33700302,ACTIVITY_CHAIN,aux.FALSE)
end
function c33700402.condition(e,tp,eg,ep,ev,re,r,rp)
	local ecount = Duel.GetCustomActivityCount(33700302,1-tp,ACTIVITY_CHAIN)
	return ecount >= 7
end
function c33700402.operation(e,tp,eg,ep,ev,re,r,rp)
	local ecount = Duel.GetCustomActivityCount(33700302,1-tp,ACTIVITY_CHAIN)
	local cph = Duel.GetCurrentPhase()
	local turn = {PHASE_STANDBY,PHASE_MAIN1,PHASE_BATTLE,PHASE_MAIN2,PHASE_END}
	for _,ph in pairs(turn) do
		if cph <= ph then
			Duel.SkipPhase(Duel.GetTurnPlayer(),ph,RESET_PHASE+PHASE_END,1)
		end
	end
	if ecount >= 13 then
		local t = (Duel.GetTurnPlayer() == 1 - tp) and 2 or 1
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_SKIP_TURN)
		e1:SetTargetRange(0,1)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,t)
		e1:SetCondition(c33700402.skipcon)
		Duel.RegisterEffect(e1,tp)
	end
end
function c33700402.skipcon(e)
	return Duel.GetTurnPlayer()~=e:GetHandlerPlayer()
end
function c33700402.handcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_ONFIELD+LOCATION_HAND,0)<=Duel.GetFieldGroupCount(e:GetHandlerPlayer(),0,LOCATION_ONFIELD)
end