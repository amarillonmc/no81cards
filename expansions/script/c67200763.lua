--噩梦回廊的支配者 舞亚
function c67200763.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,67200763)
	e1:SetCost(c67200763.spcost)
	e1:SetCondition(c67200763.spcon1)
	e1:SetTarget(c67200763.sptg)
	e1:SetOperation(c67200763.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c67200763.spcon2)
	c:RegisterEffect(e2)
	if not c67200763.global_check then
		c67200763.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c67200763.spcheckop)
		Duel.RegisterEffect(ge1,0)
	end  
end
--
function c67200763.spcheckop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local p1=false
	local p2=false
	while tc do
		if tc:IsSummonPlayer(0) then p1=true else p2=true end
		tc=eg:GetNext()
	end
	if p1 then Duel.RegisterFlagEffect(0,67200763,RESET_PHASE+PHASE_END,0,1) end
	if p2 then Duel.RegisterFlagEffect(1,67200763,RESET_PHASE+PHASE_END,0,1) end
end
--
function c67200763.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasable() end
	Duel.Release(c,REASON_COST)
end
function c67200763.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(1-tp,67200763)==0 and Duel.IsExistingMatchingCard(c67200763.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c67200763.cfilter(c)
	return c:IsFaceup() and c:IsCode(67200755)
end
function c67200763.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(1-tp,67200763)~=0 and Duel.IsExistingMatchingCard(c67200763.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c67200763.spfilter(c,e,tp)
	return c:IsSetCard(0x367d) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function c67200763.fselect(g,tp)
	return Duel.IsExistingMatchingCard(c67200763.lkfilter,tp,LOCATION_EXTRA,0,1,nil,g)
end
function c67200763.lkfilter(c,g)
	return c:IsSetCard(0x367d) and c:IsLinkSummonable(g,nil,g:GetCount(),g:GetCount())
end
function c67200763.chkfilter(c,tp)
	return c:IsType(TYPE_LINK) and c:IsSetCard(0x367d) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c67200763.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if not Duel.IsPlayerCanSpecialSummonCount(tp,2) then return false end
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft<=0 then return false end
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		local cg=Duel.GetMatchingGroup(c67200763.chkfilter,tp,LOCATION_EXTRA,0,nil,tp)
		if #cg==0 then return false end
		local _,maxlink=cg:GetMaxGroup(Card.GetLink)
		if maxlink>ft then maxlink=ft end
		local g=Duel.GetMatchingGroup(c67200763.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
		return g:CheckSubGroup(c67200763.fselect,1,maxlink,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c67200763.spop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanSpecialSummonCount(tp,2) then return end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c67200763.spfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
	local cg=Duel.GetMatchingGroup(c67200763.chkfilter,tp,LOCATION_EXTRA,0,nil,tp)
	local _,maxlink=cg:GetMaxGroup(Card.GetLink)
	if ft>0 and maxlink then
		if maxlink>ft then maxlink=ft end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:SelectSubGroup(tp,c67200763.fselect,false,1,maxlink,tp)
		if not sg then return end
		local tc=sg:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			tc:RegisterEffect(e2)
			tc=sg:GetNext()
		end
		Duel.SpecialSummonComplete()
		local og=Duel.GetOperatedGroup()
		Duel.AdjustAll()
		if og:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)<sg:GetCount() then return end
		local tg=Duel.GetMatchingGroup(c67200763.lkfilter,tp,LOCATION_EXTRA,0,nil,og)
		if og:GetCount()==sg:GetCount() and tg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local rg=tg:Select(tp,1,1,nil)
			Duel.LinkSummon(tp,rg:GetFirst(),og,nil,#og,#og)
		end
	end
end
