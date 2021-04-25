--里械仪者·天仪龙
if not pcall(function() require("expansions/script/c114500") end) then require("script/c114500") end
local m,cm = rscf.DefineCard(114506)
function cm.initial_effect(c)
	local e1 = rsef.I(c,"th",{1,m},"se,th",nil,LOCATION_HAND,nil,rscost.cost(Card.IsAbleToGraveAsCost,"tg"),rsop.target(cm.thfilter,"th",LOCATION_DECK),cm.thop)
	local e2 = rsef.I(c,"sp",{1,m},"sp",nil,LOCATION_HAND,nil,rscost.cost(cm.cfilter,"cf",LOCATION_HAND),cm.rittg,cm.ritop)
	local e3 = rsef.STO_FLIP(c,"th",{1,m+100},"se,th","de",nil,nil,rsop.target({cm.thfilter,"th",LOCATION_DECK},{cm.thfilter2,"th",LOCATION_GRAVE}),cm.thop2)
end
function cm.thfilter(c)
	return c:IsComplexType(TYPE_RITUAL+TYPE_MONSTER) and c:IsAbleToHand() and c:IsSetCard(0xca1)
end
function cm.thop(e,tp)
	rsop.SelectToHand(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,{})
end
function cm.cfilter(c)
	return not c:IsPublic() and c:IsComplexType(TYPE_RITUAL+TYPE_MONSTER) 
end
function cm.rcheck(gc)
	return  function(tp,g,c)
				return g:IsContains(gc)
			end
end
function cm.ritfilter(c)
	return c:IsSetCard(0xca1)
end
function cm.rittg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		aux.RCheckAdditional=cm.rcheck(c)
		local res=mg:IsContains(c) and Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND,0,1,nil,cm.ritfilter,e,tp,mg,nil,Card.GetLevel,"Greater")
		aux.RCheckAdditional=nil
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.ritop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetRitualMaterial(tp)
	if c:GetControler()~=tp or not c:IsRelateToEffect(e) or not mg:IsContains(c) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	aux.RCheckAdditional=cm.rcheck(c)
	local tg=Duel.SelectMatchingCard(tp,aux.RitualUltimateFilter,tp,LOCATION_HAND,0,1,1,nil,cm.ritfilter,e,tp,mg,nil,Card.GetLevel,"Greater")
	local tc=tg:GetFirst()
	if tc then
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
		mg:RemoveCard(tc)
		end
		if not mg:IsContains(c) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		Duel.SetSelectedCard(c)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Greater")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Greater")
		aux.GCheckAdditional=nil
		if not mat or mat:GetCount()==0 then
			aux.RCheckAdditional=nil
			return
		end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
	aux.RCheckAdditional=nil
end
function cm.thfilter2(c)
	return c:IsComplexType(TYPE_RITUAL+TYPE_SPELL) and c:IsAbleToHand()
end
function cm.thop2(e,tp)
	local ct,og,tc = rsop.SelectToHand(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,{})
	if tc and tc:IsLocation(LOCATION_HAND) then
		rsop.SelectOC(nil,true)
		rsop.SelectToHand(tp,aux.NecroValleyFilter(cm.thfilter2),tp,LOCATION_GRAVE,0,1,1,nil,{})
	end
end