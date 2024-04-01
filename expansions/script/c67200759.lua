--噩梦回廊的探索者 弥生
function c67200759.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,67200759)
	e1:SetCondition(c67200759.spcon1)
	e1:SetTarget(c67200759.sptg)
	e1:SetOperation(c67200759.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c67200759.spcon2)
	c:RegisterEffect(e2)
	--zha shi
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67200759,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION+CATEGORY_GRAVE_SPSUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1,67200748)
	e3:SetCost(c67200759.tscost)
	e3:SetTarget(c67200759.tstg)
	e3:SetOperation(c67200759.tsop)
	c:RegisterEffect(e3)
	if not c67200759.global_check then
		c67200759.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c67200759.spcheckop)
		Duel.RegisterEffect(ge1,0)
	end 
end
function c67200759.spcheckop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local p1=false
	local p2=false
	while tc do
		if tc:IsSummonPlayer(0) then p1=true else p2=true end
		tc=eg:GetNext()
	end
	if p1 then Duel.RegisterFlagEffect(0,67200759,RESET_PHASE+PHASE_END,0,1) end
	if p2 then Duel.RegisterFlagEffect(1,67200759,RESET_PHASE+PHASE_END,0,1) end
end
function c67200759.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(1-tp,67200759)==0 and Duel.IsExistingMatchingCard(c67200759.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c67200759.spfilter(c,e,tp)
	return c:IsSetCard(0x367d) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsFaceup()
end
function c67200759.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>=2 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
		and Duel.IsExistingMatchingCard(c67200759.spfilter,tp,LOCATION_REMOVED,0,1,c,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,2,tp,LOCATION_REMOVED)
end
function c67200759.linkfilter(c)
	return c:IsLinkSummonable(nil) and c:IsSetCard(0x367d)
end
function c67200759.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsCanBeSpecialSummoned(e,0,tp,false,false) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c67200759.spfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		g:AddCard(c)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		if Duel.GetMZoneCount(tp)<1 then return end
		local gg=Duel.GetMatchingGroup(c67200759.linkfilter,tp,LOCATION_EXTRA,0,nil)
		if gg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(67200759,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tc=gg:Select(tp,1,1,nil):GetFirst()
			Duel.LinkSummon(tp,tc,nil)
		end
	end
end
--
function c67200759.cfilter(c)
	return c:IsFaceup() and c:IsCode(67200755)
end
function c67200759.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(1-tp,67200759)~=0 and Duel.IsExistingMatchingCard(c67200759.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
--
function c67200759.costfilter(c)
	return c:IsSetCard(0x367d) and c:IsAbleToRemoveAsCost()
end
function c67200759.tscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200759.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c67200759.costfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c67200759.tstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand()
		or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)) end
end
function c67200759.tsop(e,tp,eg,ep,ev,re,r,rp)
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

