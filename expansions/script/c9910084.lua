--沐光凯旋之月神
function c9910084.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9910084,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910084)
	e1:SetCondition(c9910084.spcon1)
	e1:SetCost(c9910084.spcost)
	e1:SetTarget(c9910084.sptg)
	e1:SetOperation(c9910084.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCondition(c9910084.spcon2)
	c:RegisterEffect(e2)
	--Lock S&T
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c9910084.lcktg)
	e3:SetOperation(c9910084.lckop)
	c:RegisterEffect(e3)
end
function c9910084.cfilter(c)
	return c:IsFaceup() and c:IsCode(9910059)
end
function c9910084.spcon1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()==0 then return false end
	local tg=g:GetMaxGroup(Card.GetAttack)
	return tg:IsExists(Card.IsControler,1,nil,1-tp)
		and not Duel.IsEnvironment(9910059,tp) and not Duel.IsExistingMatchingCard(c9910084.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c9910084.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()==0 then return false end
	local tg=g:GetMaxGroup(Card.GetAttack)
	return tg:IsExists(Card.IsControler,1,nil,1-tp)
		and (Duel.IsEnvironment(9910059,tp) or Duel.IsExistingMatchingCard(c9910084.cfilter,tp,LOCATION_ONFIELD,0,1,nil))
end
function c9910084.rfilter(c,tp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()==0 then return false end
	local tg=g:GetMaxGroup(Card.GetAttack)
	return tg:IsContains(c) and c:IsReleasable()
end
function c9910084.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910084.rfilter,tp,0,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c9910084.rfilter,tp,0,LOCATION_MZONE,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c9910084.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9910084.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c9910084.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9910084.splimit(e,c)
	return not c:IsRace(RACE_FAIRY)
end
function c9910084.lcktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(1-tp) and chkc:IsFacedown() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFacedown,tp,0,LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEDOWN)
	Duel.SelectTarget(tp,Card.IsFacedown,tp,0,LOCATION_SZONE,1,1,nil)
end
function c9910084.lckop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
	end
end
