--人理之基 曼迪卡尔多
function c22021190.initial_effect(c)
	aux.AddCodeList(c,22023340)
	--oh do to ha
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22021190,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,22021191)
	e3:SetCondition(c22021190.odthcon)
	e3:SetOperation(c22021190.odthop)
	c:RegisterEffect(e3)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22021190,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,22021190)
	e1:SetCondition(c22021190.condition)
	e1:SetTarget(c22021190.sptg1)
	e1:SetOperation(c22021190.spop1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22021190,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1,22021190)
	e2:SetCondition(c22021190.condition1)
	e2:SetTarget(c22021190.sptg1)
	e2:SetOperation(c22021190.spop1)
	c:RegisterEffect(e2)
end
function c22021190.odthcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c22021190.odthop(e,tp,eg,ep,ev,re,r,rp)
		Duel.RegisterFlagEffect(tp,22023340,0,0,0)
		Duel.RegisterFlagEffect(tp,22023340,0,0,0)
		Duel.RegisterFlagEffect(tp,22023340,0,0,0)
		Duel.Hint(HINT_CARD,0,22023340)
		Duel.Hint(HINT_CARD,0,22023340)
		Duel.Hint(HINT_CARD,0,22023340)
end
function c22021190.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,22023340)>0 and Duel.GetFlagEffect(tp,22023340)<3
end
function c22021190.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c22021190.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
	Duel.SpecialSummonComplete()
end
function c22021190.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,22023340)>2
end