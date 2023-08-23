--方舟骑士将火照影
c29091651.named_with_Arknight=1
function c29091651.initial_effect(c)
	aux.AddCodeList(c,29008292)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RELEASE+CATEGORY_DAMAGE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c29091651.target)
	e1:SetOperation(c29091651.activate)
	c:RegisterEffect(e1)
end
function c29091651.filter(c,e,tp)
	return c:IsCode(29008292)
end
function c29091651.filter2(c,e,tp)
	return bit.band(c:GetType(),0x81)==0x81 and c:IsCode(29008292) and Duel.GetLP(tp)>c:GetLevel()*400
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,true)
end
function c29091651.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		local b1=Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,c29091651.filter,e,tp,mg,nil,Card.GetLevel,"Greater")
		local b2=Duel.IsExistingMatchingCard(c29091651.filter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp)
		return b1 or b2
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c29091651.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	local mg=Duel.GetRitualMaterial(tp)
	local g1=Duel.GetMatchingGroup(aux.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,c29091651.filter,e,tp,mg,nil,Card.GetLevel,"Greater")
	local g2=Duel.GetMatchingGroup(c29091651.filter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	g:Merge(g1)
	g:Merge(g2)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	if g1:IsContains(tc) and (not g2:IsContains(tc) or Duel.SelectOption(tp,aux.Stringid(29091651,0),aux.Stringid(29091651,1))==0) then
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
		local dam=tc:GetLevel()*400
		if Duel.Damage(tp,dam,REASON_EFFECT)~=dam then return end
		tc:SetMaterial(nil)
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
