--异热同心从者-混沌贤者
function c75038079.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75038079,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,75038079)
	e1:SetCost(c75038079.spcost)
	e1:SetTarget(c75038079.sptg)
	e1:SetOperation(c75038079.spop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetDescription(aux.Stringid(75038079,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,75038079+1)
	e2:SetCondition(c75038079.descon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c75038079.destg)
	e2:SetOperation(c75038079.desop)
	c:RegisterEffect(e2)
end
function c75038079.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_EXTRA,0,1,nil,56840427) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_EXTRA,0,1,1,nil,56840427)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c75038079.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c75038079.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp) and aux.NecroValleyFilter()(c)
end
function c75038079.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToChain() or Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	local b1=Duel.GetMZoneCount(1-tp)>0
		and Duel.IsExistingMatchingCard(c75038079.spfilter,tp,0,LOCATION_GRAVE,1,nil,e,tp)
	local b2=true
	local b3=true
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(75038079,0)},
		{b2,aux.Stringid(75038079,1)},
		{b3,aux.Stringid(75038079,2)})
	if op~=3 then Duel.BreakEffect() end
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,c75038079.spfilter,tp,0,LOCATION_GRAVE,1,1,nil,e,tp):GetFirst()
		if Duel.SpecialSummonStep(sc,0,tp,1-tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e2)
		end
		Duel.SpecialSummonComplete()
	elseif op==2 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(c75038079.immfilter)
		e1:SetValue(c75038079.efilter)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c75038079.immfilter(e,c)
	return c:IsSetCard(0x107f) and c:IsRankAbove(5)
end
function c75038079.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer() and re:IsActivated() and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function c75038079.cfilter(c)
	return c:IsSetCard(0x107f) and c:IsRankAbove(5) and c:IsFaceup()
end
function c75038079.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c75038079.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c75038079.desfilter(c)
	return c:IsFaceup()
end
function c75038079.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c75038079.desfilter(chkc) end--chkc:IsLocation(LOCATION_MZONE)
	if chk==0 then return Duel.IsExistingTarget(c75038079.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c75038079.desfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c75038079.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToChain() then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
