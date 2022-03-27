--巧壳将的抗争
function c67200569.initial_effect(c)
 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,67200569+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c67200569.target)
	e1:SetOperation(c67200569.activate)
	c:RegisterEffect(e1)
end
function c67200569.spfilter(c,e,tp)
	return c:IsSetCard(0x676) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
--
function c67200569.exfilter3(c)
	return c:IsLocation(LOCATION_EXTRA) and c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c67200569.gcheck(g,ft1,ft3,ect,ft)
	return aux.dncheck(g) and #g<=ft 
		and g:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)<=ft1
		and g:FilterCount(c67200569.exfilter3,nil)<=ft3  
		and g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)<=ect
end
function c67200569.filter(c)
	return c:IsLinkSummonable(nil) and c:IsSetCard(0x676)
end
function c67200569.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or Duel.GetLocationCountFromEx(tp,tp,nil,c)>0)
		and Duel.IsExistingMatchingCard(c67200569.spfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e,tp,g) and Duel.IsExistingMatchingCard(c67200569.filter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_EXTRA)
end
function c67200569.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft3=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)
	local ft=Duel.GetUsableMZoneCount(tp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then
		if ft1>0 then ft1=1 end
		if ft3>0 then ft3=1 end
		ft=1
	end
	--local cg=Duel.GetMatchingGroup(c67200569.chkfilter,tp,LOCATION_EXTRA,0,nil,tp)
	local ect=(c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]) or ft
	local loc=0
	if ft1>0 then loc=loc+LOCATION_GRAVE end
	if  ect>0 and ft3>0 then loc=loc+LOCATION_EXTRA end
	if loc==0 then return end
	local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c67200569.spfilter),tp,loc,0,nil,e,tp)
	if sg:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local slg=sg:SelectSubGroup(tp,c67200569.gcheck,false,1,maxlink,ft1,ft3,ect,ft)
	if not slg then return end
	local tc=slg:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		tc:RegisterEffect(e2)
		tc=slg:GetNext()
	end
	Duel.SpecialSummonComplete()
	--
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	Duel.BreakEffect()
	local ggg=Duel.SelectMatchingCard(tp,c67200569.filter,tp,LOCATION_EXTRA,0,1,1,nil)
	local tcc=ggg:GetFirst()
	if tcc then
		Duel.LinkSummon(tp,tcc,nil)
	end
end

