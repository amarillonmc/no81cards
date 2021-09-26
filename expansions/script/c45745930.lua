--极翼灵兽 七夕青鸟
function c45745930.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(45745930,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,45745930)
	e1:SetCondition(c45745930.spcon1)
	e1:SetTarget(c45745930.sptg1)
	e1:SetOperation(c45745930.spop1)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(45745930,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(1,45745970)
	e2:SetCondition(c45745930.spcon)
	e2:SetTarget(c45745930.target1)
	e2:SetOperation(c45745930.operation1)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(45745930,4))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,45745971)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c45745930.eqcon)
	e3:SetTarget(c45745930.sptg2)
	e3:SetOperation(c45745930.spop2)
	c:RegisterEffect(e3)

end
--e1
function c45745930.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x881)
end
function c45745930.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c45745930.cfilter,tp,LOCATION_MZONE,0,1,nil) and (Duel.GetTurnPlayer()~=tp
		and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2))
end
function c45745930.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c45745930.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
--e2
function c45745930.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c45745930.filter4(c)
	return c:IsFaceup() and c:GetLevel()>0 and c:IsSetCard(0x881) 
end
function c45745930.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c45745930.filter4(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c45745930.filter4,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c45745930.filter4,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local op=0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	if g:GetFirst():IsLevel(1,2) then
		op=Duel.SelectOption(tp,aux.Stringid(45745930,2))
	else
		op=Duel.SelectOption(tp,aux.Stringid(45745930,2),aux.Stringid(45745930,3))
	end
	e:SetLabel(op)
end
function c45745930.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		if e:GetLabel()==0 then
			e1:SetValue(2)
		else
			e1:SetValue(-2)
		end
		tc:RegisterEffect(e1)
	end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c45745930.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)

	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetTargetRange(1,0)
	e3:SetTarget(c45745930.splimit2)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c45745930.splimit(e,c)
	return c:IsLocation(LOCATION_DECK) and not c:IsSetCard(0x881)
end
function c45745930.splimit2(e,c)
	return c:IsLocation(LOCATION_EXTRA) and c:IsType(TYPE_LINK) and not c:IsSetCard(0x323) 
end
--e4
function c45745930.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c45745930.spfilter1(c,e,tp)
	return (c:IsSetCard(0x881) and c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_SYNCHRO)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c45745930.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c45745930.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c45745930.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c45745930.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end