
function c71400032.op1(e,tp,eg,ep,ev,re,r,rp)
	local cnt=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if cnt<=0 or not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then cnt=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c71400032.filter1,tp,LOCATION_HAND,0,1,cnt,nil,e,tp)
	if g:GetCount()==0 then return end
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	local lnkg=Duel.GetMatchingGroup(c71400032.lnkfilter,tp,LOCATION_EXTRA,0,nil)
	if lnkg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(71400032,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local lnk=lnkg:Select(tp,1,1,nil):GetFirst()
		Duel.SpecialSummonRule(tp,lnk,SUMMON_TYPE_LINK)
	end
end
function c71400032.filter1(c,e,tp)
	return c:IsSetCard(0x714) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c71400032.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c71400032.filter1,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,0)
end
function c71400032.con1(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
--Select Link Monsters
function c71400032.lnkfilter(c)
	return c:IsSetCard(0x716) and c:IsSpecialSummonable(SUMMON_TYPE_LINK)
end