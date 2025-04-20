--迷途罪械的颂唱
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.filter(c,e,tp)
	return c:IsRace(RACE_MACHINE)
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x9a12) and c:IsType(TYPE_MONSTER) and c:IsLevelAbove(1)
end
function s.mfilter(c)
	return c:GetLevel()>0 and c:IsRace(RACE_MACHINE) and c:IsAbleToDeck()
end
function s.RitualUltimateFilter(c,filter,e,tp,m1,m2,level_function,greater_or_equal,chk)
	local spg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_DECK,0,nil)
	if spg then
		spg=spg:Filter(Card.IsCanBeRitualMaterial,c,c)
	end
	if bit.band(c:GetType(),0x81)~=0x81 or (filter and not filter(c,e,tp,chk))
	 or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m1:Filter(Card.IsCanBeRitualMaterial,c,c)
	if m2 then
		mg:Merge(m2)
	end
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,c,tp)
	else
		mg:RemoveCard(c)
	end
	local lv=level_function(c)
	local res=false
	local tc=spg:GetFirst()
	Auxiliary.GCheckAdditional=Auxiliary.RitualCheckAdditional(c,lv,greater_or_equal)
	if not tc then
		res=mg:CheckSubGroup(Auxiliary.RitualCheck,1,lv,tp,c,lv,greater_or_equal)
	else
		while tc do
			mg:AddCard(tc)
			if mg:CheckSubGroup(Auxiliary.RitualCheck,1,lv,tp,c,lv,greater_or_equal) then
				return true
			else
				mg:RemoveCard(tc)
			end
			tc=spg:GetNext()
		end
	
	end
	Auxiliary.GCheckAdditional=nil

	return res
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg1=Duel.GetRitualMaterial(tp)
		local mg2=Duel.GetMatchingGroup(s.mfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
		return Duel.IsExistingMatchingCard(s.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,s.filter,e,tp,mg1,mg2,s.GetLevel2,"Greater")
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,LOCATION_GRAVE)
end
function s.GetLevel2(c)
	return c:GetLevel()*2
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	::cancel::
	local mg1=Duel.GetRitualMaterial(tp)
	local mg2=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.mfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,s.filter,e,tp,mg1,mg2,s.GetLevel2,"Greater")
	local tc=g:GetFirst()
	if tc then
		local mg=mg1:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		mg:Merge(mg2)
		local spg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_DECK,0,nil)
		if spg then
			spg=spg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
			mg:Merge(spg)
		end
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,s.GetLevel2(tc),"Greater")
		local mat=mg:SelectSubGroup(tp,s.RitualCheck,true,1,s.GetLevel2(tc),tp,tc,s.GetLevel2(tc),"Greater")
		aux.GCheckAdditional=nil
		if not mat then goto cancel end
		tc:SetMaterial(mat)
		local mat2=mat:Filter(Card.IsLocation,nil,LOCATION_GRAVE+LOCATION_REMOVED):Filter(Card.IsRace,nil,RACE_MACHINE)
		if #mat2>0 then
			Duel.HintSelection(mat2)
		end
		local mat3=mat:Filter(Card.IsLocation,nil,LOCATION_DECK)
		if #mat3>0 then
			Duel.HintSelection(mat3)
		end

		mat:Sub(mat2)
		mat:Sub(mat3)
		Duel.ReleaseRitualMaterial(mat)
		Duel.SendtoGrave(mat3,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL+REASON_RELEASE)
		Duel.SendtoDeck(mat2,nil,SEQ_DECKSHUFFLE,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function s.RitualCheck(g,tp,c,lv,greater_or_equal)
	local res=true
	local tc=g:GetFirst()
	local count=0
	while tc do
		if tc:IsLocation(LOCATION_DECK) then
			count=count+1
		end
		if count>1 then
			res=false
			break
		end
		tc=g:GetNext()
	end
	return Auxiliary["RitualCheck"..greater_or_equal](g,c,lv)
	and Duel.GetMZoneCount(tp,g,tp)>0 and (not c.mat_group_check or c.mat_group_check(g,tp))
		and (not Auxiliary.RCheckAdditional or Auxiliary.RCheckAdditional(tp,g,c))
		and res
end
