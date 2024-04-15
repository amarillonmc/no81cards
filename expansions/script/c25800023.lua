--小小的成长
local m = 25800023
local cm = _G["c"..m]
function cm.initial_effect(c)
		--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_STANDBY_PHASE,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE+TIMING_DRAW_PHASE)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.filter(c,e,tp)
	return  aux.IsCodeListed(c,m)
end
function cm.atkfilter(c,e)
	return  (c:IsFaceup() or c:IsPublic()) and c:GetLevel()>c:GetOriginalLevel() and c:GetOriginalLevel()>0 and not c:IsImmuneToEffect(e) 
end

function cm.atkdiff(c,diff)
	return c:GetLevel()>=c:GetOriginalLevel()+diff
end
function cm.filter2(c,e,tp,atkg)
	if  Duel.GetLocationCount(tp,LOCATION_MZONE)==0
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false) then return false end
	return atkg:IsExists(cm.atkdiff,1,nil,c:GetLevel()) and aux.IsCodeListed(c,m)
end
function cm.RitualUltimateFilter(c,filter,e,tp,m1,m2,level_function,greater_or_equal,chk)
	if  (filter and not filter(c,e,tp,chk)) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true,POS_FACEUP) then return false end
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
	aux.GCheckAdditional=aux.RitualCheckAdditional(c,lv,greater_or_equal)
	local res=mg:CheckSubGroup(aux.RitualCheck,1,lv,tp,c,lv,greater_or_equal)
	aux.GCheckAdditional=nil
	return res
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		local atkg=Duel.GetMatchingGroup(cm.atkfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil,e)
		local b1=Duel.IsExistingMatchingCard(cm.RitualUltimateFilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,cm.filter,e,tp,mg,nil,Card.GetLevel,"Greater")
		local b2=Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,atkg)
		return b1 or b2
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	local mg=Duel.GetRitualMaterial(tp)
	local atkg=Duel.GetMatchingGroup(cm.atkfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil,e)
	local g1=Duel.GetMatchingGroup(cm.RitualUltimateFilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,cm.filter,e,tp,mg,nil,Card.GetLevel,"Greater")
	local g2=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp,atkg)
	g:Merge(g1)
	g:Merge(g2)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	if g1:IsContains(tc) and (not g2:IsContains(tc) or Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))==0) then
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Greater")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Greater")
		aux.GCheckAdditional=nil
		if not mat or mat:GetCount()==0 then return end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local atkg2=atkg:FilterSelect(tp,cm.atkdiff,1,1,nil,tc:GetLevel())
		if atkg2:GetCount()==0 then return end
		local sc=atkg2:GetFirst()
		local diff=tc:GetLevel()
		local e1=Effect.CreateEffect(sc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(-diff)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e1)
		tc:SetMaterial(nil)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)
		tc:CompleteProcedure()
	  end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.spcon1)
	e1:SetOperation(cm.desop2)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)

end
---
function cm.disfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsFaceup() 
end
function cm.spcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(cm.disfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.desop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,0,nil,TYPE_RITUAL)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end