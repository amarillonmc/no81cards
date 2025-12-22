--叙事奇点
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_ONFIELD,0,e:GetHandler())==0
end
function s.spfilter(c,e,tp,zone)
	return c:IsSetCard(0x838) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE,tp,zone)
end
function s.get_zone(tp)
	local zone=0
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	for tc in aux.Next(g) do
		local zone2=tc:GetColumnZone(LOCATION_MZONE,0,0,tp)
		if Duel.CheckLocation(tp,LOCATION_MZONE,math.log(zone2,2)) then
			zone=zone|zone2
		end
	end
	return zone&0x1f
end
function s.rmfilter(c)
	return c:IsAbleToRemove() and c:GetColumnGroup():IsExists(Card.IsControler,1,nil,1-c:GetControler())
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local zone=s.get_zone(tp)
	if chk==0 then return zone~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,zone) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local zone=s.get_zone(tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_DECK,0,nil,e,tp,zone)
	if ft>#g then fg=#g end
	if #g>0 then
		--Special Summon
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,ft)
		if sg then
			for tc in aux.Next(sg) do
				if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE,zone) then
					--negate effects
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_DISABLE)
					e1:SetReset(RESETS_STANDARD)
					tc:RegisterEffect(e1)
					local e2=e1:Clone()
					e2:SetCode(EFFECT_DISABLE_EFFECT)
					tc:RegisterEffect(e2)
				end
			end
			Duel.SpecialSummonComplete()
		end
	end
	local og=Duel.GetMatchingGroup(s.rmfilter,1-tp,LOCATION_ONFIELD,0,nil)
	if #og>0 and Duel.SelectYesNo(1-tp,aux.Stringid(id,0)) then
		Duel.BreakEffect()
		--opponent banishes
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
		local rg=og:Select(1-tp,1,#og,nil)
		local dg=Group.CreateGroup()
		for tc in aux.Next(rg) do
			local cg=tc:GetColumnGroup():Filter(Card.IsControler,nil,tp)
			dg:Merge(cg)
		end
		if Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)>0 then
			Duel.Remove(dg,POS_FACEUP,REASON_EFFECT)
		end
	end
end