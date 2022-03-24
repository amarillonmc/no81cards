--虚拟主播 乙女音 SP
function c33711008.initial_effect(c)
	c:EnableReviveLimit() 
	--sp1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33711008,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCountLimit(1)
	e1:SetCondition(c33711008.spcon)
	e1:SetTarget(c33711008.sptg)
	e1:SetOperation(c33711008.spop)
	c:RegisterEffect(e1)   
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33711008,2))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLED)
	e2:SetCountLimit(1)
	e2:SetCondition(c33711008.thcon)
	e2:SetTarget(c33711008.thtg)
	e2:SetOperation(c33711008.thop)
	c:RegisterEffect(e2)   
end
function c33711008.spcon(e,tp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 and Duel.GetCurrentPhase()==PHASE_MAIN1
end
function c33711008.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c33711008.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) then return end
		if Duel.SpecialSummonStep(e:GetHandler(),0,tp,tp,true,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetReset(RESET_EVENT+0xff0000)
			e1:SetCode(EFFECT_SET_BASE_ATTACK)
			e1:SetValue(c:GetTextAttack()/2)
			c:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e2:SetRange(LOCATION_MZONE)
			e2:SetReset(RESET_EVENT+0xff0000)
			e2:SetCode(EFFECT_SET_BASE_DEFENSE)
			e2:SetValue(c:GetTextDefense()/2)
			c:RegisterEffect(e2)
			Duel.SpecialSummonComplete()
			if Duel.GetTurnCount()<2 then
				Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
				Duel.SkipPhase(tp,PHASE_END,RESET_PHASE+PHASE_END,1)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e1:SetCode(EFFECT_SKIP_TURN)
				e1:SetTargetRange(0,1)
				e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
				Duel.RegisterEffect(e1,tp)
				Duel.SkipPhase(tp,PHASE_DRAW,RESET_PHASE+PHASE_END,2)
				Duel.SkipPhase(tp,PHASE_STANDBY,RESET_PHASE+PHASE_END,2)
				Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,2)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_FIELD)
				e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e2:SetCode(EFFECT_CANNOT_EP)
				e2:SetTargetRange(1,0)
				e2:SetReset(RESET_PHASE+PHASE_MAIN1+RESET_SELF_TURN)
				Duel.RegisterEffect(e2,tp)
			else
				Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
			end
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DIRECT_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
			c:RegisterEffect(e1)
		end
end
function c33711008.thcon(e)
	return Duel.GetAttacker()==e:GetHandler()
end
function c33711008.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c33711008.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SkipPhase(tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	if Duel.GetActivityCount(tp,ACTIVITY_SUMMON)==0 and Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)==0 and e:GetHandler():IsAbleToHand() and Duel.SelectYesNo(tp,aux.Stringid(33711008,0)) then
		Duel.SendtoHand(e:GetHandler(),tp,REASON_EFFECT)
	end
end