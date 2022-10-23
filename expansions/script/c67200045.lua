--恶魔的威吓
function c67200045.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCountLimit(1,67200045+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c67200045.condition)
	e1:SetTarget(c67200045.target)
	e1:SetOperation(c67200045.activate)
	c:RegisterEffect(e1)	
end
function c67200045.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsType(TYPE_PENDULUM)
end
function c67200045.filter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsRace(RACE_FIEND) and not c:IsForbidden()
end
function c67200045.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200045.filter,tp,LOCATION_DECK,0,1,nil) and Duel.CheckLocation(tp,LOCATION_PZONE,0) and Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c67200045.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) or not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	local ppp=Duel.GetTurnPlayer()
	local tc1=Duel.GetAttacker()
	local g=Duel.SelectMatchingCard(tp,c67200045.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tc2=g:GetFirst()
	if Duel.MoveToField(tc1,tp,tp,LOCATION_PZONE,POS_FACEUP,false) then
		if Duel.MoveToField(tc2,tp,tp,LOCATION_PZONE,POS_FACEUP,false) then
			Duel.BreakEffect()
			Duel.SkipPhase(ppp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE_STEP,1)
			tc2:SetStatus(STATUS_EFFECT_ENABLED,true)
		end
		tc1:SetStatus(STATUS_EFFECT_ENABLED,true)
	end
end