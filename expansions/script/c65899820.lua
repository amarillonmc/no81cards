local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.lv_or_rk(c)
	if c:IsType(TYPE_XYZ) then return c:GetRank()
	else return c:GetLevel() end
end
function s.sumfilter(sg)
	return sg:GetSum(s.lv_or_rk)==18
end
function s.gcheck(sg)
	return sg:GetSum(s.lv_or_rk)<=18
end
function s.matfilter(c)
	return c:IsFaceup() and (c:IsLevelAbove(1) or c:IsRankAbove(1))
end
function s.xyzfilter(c,e,tp,mg)
	return c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,mg,c)>0
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(s.matfilter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then
		return aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_XMATERIAL)
			and mg:CheckSubGroup(s.sumfilter,1,#mg)
			and Duel.IsExistingMatchingCard(s.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	local mg=Duel.GetMatchingGroup(s.matfilter,tp,LOCATION_MZONE,0,nil)
	if mg:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	aux.GCheckAdditional=s.gcheck
	local sg=mg:SelectSubGroup(tp,s.sumfilter,false,1,#mg)
	aux.GCheckAdditional=nil
	if not sg or sg:GetCount()==0 then return end
	local xyzg=Duel.GetMatchingGroup(s.xyzfilter,tp,LOCATION_EXTRA,0,nil,e,tp,sg)
	if xyzg:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=xyzg:Select(tp,1,1,nil):GetFirst()
	if not sc then return end
	if Duel.GetLocationCountFromEx(tp,tp,sg,sc)<=0 then return end
	local og=Group.CreateGroup()
	local tc=sg:GetFirst()
	while tc do
		local sg1=tc:GetOverlayGroup()
		og:Merge(sg1)
		tc=sg:GetNext()
	end
	Duel.SendtoGrave(og,REASON_RULE)
	sc:SetMaterial(sg)
	Duel.Overlay(sc,sg)
	if Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)>0 then
		sc:CompleteProcedure()
	end
end