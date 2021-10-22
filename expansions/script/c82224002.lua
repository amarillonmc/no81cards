function c82224002.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMINGS_CHECK_MONSTER+TIMING_SSET)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_CANNOT_INACTIVATE)
	e1:SetCondition(c82224002.con)
	e1:SetOperation(c82224002.activate)
	e1:SetCost(c82224002.cost)
	e1:SetCountLimit(1,82224002+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c82224002.handcon)
	c:RegisterEffect(e2)
end
function c82224002.handcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_ONFIELD,LOCATION_ONFIELD)>=5
end
function c82224002.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c82224002.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_BATTLE_START or Duel.GetCurrentPhase()==PHASE_BATTLE or Duel.GetCurrentPhase()==PHASE_BATTLE_STEP or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c82224002.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetTurnPlayer()
	Duel.Hint(HINT_SELECTMSG,p,aux.Stringid(82224002,0))
	if Duel.GetCurrentPhase()==PHASE_MAIN1 then
		Duel.SkipPhase(p,PHASE_MAIN1,RESET_PHASE+PHASE_BATTLE,1)
	else
		if Duel.GetCurrentPhase()==PHASE_BATTLE_START or Duel.GetCurrentPhase()==PHASE_BATTLE or Duel.GetCurrentPhase()==PHASE_BATTLE_STEP then
			Duel.SkipPhase(p,PHASE_BATTLE,RESET_PHASE+PHASE_MAIN2,1)
		else
			Duel.SkipPhase(p,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
		end
	end
end
