local m=15005730
local cm=_G["c"..m]
cm.name="德尔塔式骸神化"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end
function cm.filter(c)
	return c:IsFaceupEx() and c:IsSetCard(0xcf3f)
end
function cm.flipfilter(c)
	return c:IsFacedown() and c:IsLocation(LOCATION_MZONE)
end
function cm.mustflipfilter(c,tp)
	local mg=Duel.GetRitualMaterial(tp)
	return c:IsLocation(LOCATION_MZONE) and not mg:IsContains(c)
end
function cm.mustreleasefilter(c,tp)
	local mg=Duel.GetRitualMaterial(tp)
	return c:IsLocation(LOCATION_MZONE) and mg:IsContains(c) and Duel.GetMZoneCount(tp,c,tp)>0
end
function cm.RitualGCheck(g,mustg,tp,tc,lv,Greater)
	local res=0
	if mustg then
		local tc=mustg:GetFirst()
		while tc do
			if g:IsContains(tc) then res=1 break end
			tc=mustg:GetNext()
		end
	end
	return aux.RitualCheck(g,tp,tc,lv,Greater) and (res==1 or Duel.GetMZoneCount(tp)>0)
end
function cm.SetGCheck(g,sg,mg,tp)
	local res=1
	if mg then
		local tc=mg:GetFirst()
		while tc do
			if not g:IsContains(tc) then res=0 end
			tc=mg:GetNext()
		end
	end
	return res==1 and (#g<#sg or Duel.GetMZoneCount(tp)>0)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		local sg=Duel.GetMatchingGroup(cm.flipfilter,tp,LOCATION_MZONE,0,nil)
		return Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_REMOVED,0,1,nil,cm.filter,e,tp,mg,sg,Card.GetLevel,"Greater")
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_REMOVED)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	::cancel::
	local mg=Duel.GetRitualMaterial(tp)
	local sg=Duel.GetMatchingGroup(cm.flipfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,aux.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_REMOVED,0,1,1,nil,cm.filter,e,tp,mg,sg,Card.GetLevel,"Greater")
	local tc=tg:GetFirst()
	if tc then
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if sg then
			mg:Merge(sg)
		end
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Greater")
		local mustg=mg:Filter(cm.mustreleasefilter,nil,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local mat=mg:SelectSubGroup(tp,cm.RitualGCheck,true,1,tc:GetLevel(),mustg,tp,tc,tc:GetLevel(),"Greater")
		aux.GCheckAdditional=nil
		if not mat then goto cancel end
		tc:SetMaterial(mat)
		local mat2=mat:Filter(cm.flipfilter,nil)
		local mat3=mat:Filter(cm.mustflipfilter,nil,tp)
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
		local mat4=mat2:SelectSubGroup(tp,cm.SetGCheck,false,0,#mat2,mat2,mat3,tp)
		mat:Sub(mat4)
		Duel.ReleaseRitualMaterial(mat)
		Duel.ChangePosition(mat4,POS_FACEUP_DEFENSE)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end