--单调少女世界
function c9310016.initial_effect(c)
	--synchro summon
	aux.AddSynchroMixProcedure(c,c9310016.matfilter,nil,nil,aux.NonTuner(Card.IsType,TYPE_RITUAL),1,99)
	c:EnableReviveLimit()
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9310016,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c9310016.thcon)
	e1:SetTarget(c9310016.thtg)
	e1:SetOperation(c9310016.thop)
	c:RegisterEffect(e1)
	--nontuner
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_NONTUNER)
	e2:SetValue(c9310016.tnval)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9310016,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,9311016)
	e3:SetCondition(c9310016.spcon)
	e3:SetTarget(c9310016.sptg)
	e3:SetOperation(c9310016.spop)
	c:RegisterEffect(e3)
end
function c9310016.matfilter(c)
	return c:IsSynchroType(TYPE_TUNER) or (c:IsAttack(1550) and c:IsDefense(1050))
end
function c9310016.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c9310016.thfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsLevel(4) and c:IsAbleToHand()
end
function c9310016.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c9310016.thfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil) end
	local g=Duel.GetMatchingGroup(c9310016.thfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c9310016.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c9310016.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9310016.thfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0
		and ((tc:IsType(TYPE_PENDULUM) and Duel.IsExistingMatchingCard(c9310016.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)) 
		or (tc:IsType(TYPE_TUNER) and Duel.IsExistingMatchingCard(nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)))
		and Duel.SelectYesNo(tp,aux.Stringid(9310016,0)) then
		Duel.BreakEffect()
		if tc:IsType(TYPE_PENDULUM) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local g1=Duel.SelectMatchingCard(tp,c9310016.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
			if g1:GetCount()>0 then
				Duel.HintSelection(g1)
				Duel.Destroy(g1,REASON_EFFECT)
			end
		end
		if tc:IsType(TYPE_TUNER) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local g2=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
			if g2:GetCount()>0 then
				Duel.HintSelection(g2)
				Duel.Destroy(g2,REASON_EFFECT)
			end
		end
	end
end
function c9310016.tnval(e,c)
	return e:GetHandler():IsDefensePos()
end
function c9310016.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_RITUAL) and c:IsLevel(4)
end
function c9310016.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9310016.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c9310016.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9310016.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_LEVEL)
			e1:SetValue(-4)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetReset(RESET_EVENT+RESETS_REDIRECT)
			e2:SetValue(LOCATION_DECK)
			c:RegisterEffect(e2)
		end
		Duel.SpecialSummonComplete()
	end
end