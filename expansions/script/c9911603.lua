--播种者·浀巢
function c9911603.initial_effect(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,9911603)
	e1:SetCondition(c9911603.setcon)
	e1:SetCost(c9911603.setcost)
	e1:SetTarget(c9911603.settg)
	e1:SetOperation(c9911603.setop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,9911604)
	e2:SetCondition(c9911603.spcon)
	e2:SetTarget(c9911603.sptg)
	e2:SetOperation(c9911603.spop)
	c:RegisterEffect(e2)
	if not c9911603.global_check then
		c9911603.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c9911603.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c9911603.checkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO)
end
function c9911603.checkop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c9911603.checkfilter,nil)
	local tc=g:GetFirst()
	while tc do
		Duel.RegisterFlagEffect(tc:GetSummonPlayer(),9911603,RESET_PHASE+PHASE_END,0,1)
		tc=g:GetNext()
	end
end
function c9911603.setcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c9911603.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c9911603.setfilter(c,tp)
	if not (c:IsFaceupEx() and c:IsCode(9911601)) then return false end
	local loc=0
	if c:IsLocation(LOCATION_HAND) then loc=LOCATION_HAND
	elseif c:IsLocation(LOCATION_DECK) then loc=LOCATION_DECK
	elseif c:IsLocation(LOCATION_ONFIELD) then loc=LOCATION_ONFIELD
	elseif c:IsLocation(LOCATION_GRAVE) then loc=LOCATION_GRAVE end
	local b1=loc~=LOCATION_ONFIELD and c:IsSSetable()
	local b2=c:IsLocation(LOCATION_MZONE) and c:IsCanTurnSet()
	return (b1 or b2 or c:IsSSetable(true))
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,loc,1,nil,1-tp,POS_FACEDOWN,REASON_RULE)
end
function c9911603.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanRemove(1-tp) and Duel.IsExistingMatchingCard(c9911603.setfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,e:GetHandler(),tp) end
end
function c9911603.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9911603.setfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
	if not tc then return end
	local loc=0
	if tc:IsLocation(LOCATION_HAND) then loc=LOCATION_HAND
	elseif tc:IsLocation(LOCATION_DECK) then loc=LOCATION_DECK
	elseif tc:IsLocation(LOCATION_ONFIELD) then loc=LOCATION_ONFIELD
	elseif tc:IsLocation(LOCATION_GRAVE) then loc=LOCATION_GRAVE end
	local res=0
	if loc~=LOCATION_ONFIELD then
		if Duel.SSet(tp,tc)==0 then return end
	elseif tc:IsLocation(LOCATION_MZONE) then
		if Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)==0 then return end
	else
		tc:CancelToGrave()
		if Duel.ChangePosition(tc,POS_FACEDOWN)==0 then return end
		Duel.RaiseEvent(tc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
	if not Duel.IsPlayerCanRemove(1-tp) then return end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,loc,nil,1-tp,POS_FACEDOWN,REASON_RULE)
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
	local sg=g:Select(1-tp,1,1,nil)
	Duel.HintSelection(sg)
	Duel.Remove(sg,POS_FACEDOWN,REASON_RULE,1-tp)
end
function c9911603.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,9911603)>0
end
function c9911603.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9911603.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.AdjustAll()
		if Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(9911603,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,1,nil,nil)
			Duel.SynchroSummon(tp,g:GetFirst(),nil)
		end
	end
end
