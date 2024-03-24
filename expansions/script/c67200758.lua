--噩梦回廊的守护者 咲
function c67200758.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,67200758)
	e1:SetCondition(c67200758.spcon1)
	e1:SetTarget(c67200758.sptg)
	e1:SetOperation(c67200758.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c67200758.spcon2)
	c:RegisterEffect(e2)
	if not c67200758.global_check then
		c67200758.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c67200758.spcheckop)
		Duel.RegisterEffect(ge1,0)
	end 
end
function c67200758.spcheckop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local p1=false
	local p2=false
	while tc do
		if tc:IsSummonPlayer(0) then p1=true else p2=true end
		tc=eg:GetNext()
	end
	if p1 then Duel.RegisterFlagEffect(0,67200758,RESET_PHASE+PHASE_END,0,1) end
	if p2 then Duel.RegisterFlagEffect(1,67200758,RESET_PHASE+PHASE_END,0,1) end
end
function c67200758.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(1-tp,67200758)==0 and Duel.IsExistingMatchingCard(c67200758.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c67200758.spfilter(c,e,tp)
	return c:IsSetCard(0x367d) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c67200758.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>=2 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
		and Duel.IsExistingMatchingCard(c67200758.spfilter,tp,LOCATION_GRAVE,0,1,c,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,2,tp,LOCATION_GRAVE)
end
function c67200758.linkfilter(c)
	return c:IsLinkSummonable(nil) and c:IsSetCard(0x367d)
end
function c67200758.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsCanBeSpecialSummoned(e,0,tp,false,false) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c67200758.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		g:AddCard(c)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		if Duel.GetMZoneCount(tp)<1 then return end
		local gg=Duel.GetMatchingGroup(c67200758.linkfilter,tp,LOCATION_EXTRA,0,nil)
		if gg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(67200758,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tc=gg:Select(tp,1,1,nil):GetFirst()
			Duel.LinkSummon(tp,tc,nil)
		end
	end
end
--
function c67200758.cfilter(c)
	return c:IsFaceup() and c:IsCode(67200755)
end
function c67200758.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(1-tp,67200758)~=0 and Duel.IsExistingMatchingCard(c67200758.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end

