--噩梦回廊的编织者 有栖
function c67200761.initial_effect(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200761,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,67200761)
	e1:SetCost(c67200761.stcost)
	e1:SetCondition(c67200761.tfcon)
	e1:SetTarget(c67200761.sttg)
	e1:SetOperation(c67200761.stop)
	c:RegisterEffect(e1)  
	--zha shi
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67200761,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION+CATEGORY_GRAVE_SPSUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1,67200750)
	e3:SetCost(c67200761.tscost)
	e3:SetTarget(c67200761.tstg)
	e3:SetOperation(c67200761.tsop)
	c:RegisterEffect(e3)  
end
function c67200761.stcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasable() end
	Duel.Release(c,REASON_COST)
end
function c67200761.tfcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c67200761.stfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x367d) and c:IsSSetable()
end
function c67200761.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200761.stfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
end
function c67200761.cfilter(c)
	return c:IsFaceup() and c:IsCode(67200755)
end
function c67200761.checkfilter1(c,tp)
	return Duel.IsExistingMatchingCard(c67200761.cfilter,tp,LOCATION_ONFIELD,0,1,nil) and c:IsType(TYPE_TRAP)
end
function c67200761.checkfilter2(c,tp)
	return Duel.IsExistingMatchingCard(c67200761.cfilter,tp,LOCATION_ONFIELD,0,1,nil) and c:IsType(TYPE_QUICKPLAY)
end
function c67200761.stop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c67200761.stfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
		local og=Duel.GetOperatedGroup()
		if og:IsExists(c67200761.checkfilter1,1,nil,tp) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			g:GetFirst():RegisterEffect(e1)
		end
		if og:IsExists(c67200761.checkfilter2,1,nil,tp) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			g:GetFirst():RegisterEffect(e1)
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		e1:SetTargetRange(0xff,0xff)
		e1:SetValue(LOCATION_REMOVED)
		e1:SetTarget(c67200761.rmtarget)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c67200761.rmtarget(e,c)
	return c:GetOriginalType()&TYPE_SPELL~=0
end
--
function c67200761.costfilter(c)
	return c:IsSetCard(0x367d) and c:IsAbleToRemoveAsCost()
end
function c67200761.tscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200761.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c67200761.costfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c67200761.tstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand()
		or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)) end
end
function c67200761.tsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if aux.NecroValleyNegateCheck(c) then return end
	if not aux.NecroValleyFilter()(c) then return end
	local b1=c:IsAbleToHand()
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	local op=aux.SelectFromOptions(tp,{b1,1190},{b2,1152})
	if op==1 then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
	if op==2 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
