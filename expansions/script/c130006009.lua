--艾哲红石魔术师
if not pcall(function() require("expansions/script/c130001000") end) then require("script/c130001000") end
local m,cm=rscf.DefineCard(130006009)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,aux.FilterBoolFunction(Card.IsLevelAbove,1),cm.gf,2,2)
	local e1 = rsef.STO(c,EVENT_SPSUMMON_SUCCESS,"tg",nil,"tg",nil,rscon.sumtype("xyz"),nil,rsop.target(cm.tgfilter,"tg",LOCATION_DECK),cm.tgop)
	local e2 = rsef.QO(c,nil,"sp",nil,"sp",nil,LOCATION_MZONE,nil,rscost.rmxyz(1),rsop.target(cm.spfilter,"sp",LOCATION_EXTRA),cm.spop)
end
function cm.gf(g)
	return g:GetClassCount(Card.GetLevel) == 1
end
function cm.tgfilter(c,e,tp)
	local og = e:GetHandler():GetOverlayGroup()
	return c:IsAbleToGrave() and og:IsExists(Card.IsLevel,1,nil,c:GetLevel())
end 
function cm.tgop(e,tp)
	local c = rscf.GetSelf(e)
	if not c then return end
	rsop.SelectToGrave(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil,{},e,tp)
end
function cm.spfilter(c,e,tp)
	local mc = e:GetHandler()
	return aux.MustMaterialCheck(mc,tp,EFFECT_MUST_BE_XMATERIAL) and c:IsType(TYPE_XYZ) and c:IsRank(mc:GetRank() + 1) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and mc:IsCanBeXyzMaterial(c)
end 
function cm.spop(e,tp)
	local c = rscf.GetFaceUpSelf(e)
	if not c or c:IsImmuneToEffect(e) or c:IsControler(1-tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	if tc then
		local mg = c:GetOverlayGroup()
		if #mg ~= 0 then
			Duel.Overlay(tc,mg)
		end
		tc:SetMaterial(Group.FromCards(c))
		Duel.Overlay(tc,Group.FromCards(c))
		Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()
		local e1 = rsef.QO({tc,tc,true},nil,"sp",nil,"sp",nil,LOCATION_MZONE,nil,rscost.rmxyz(1),rsop.target(cm.spfilter,"sp",LOCATION_EXTRA),cm.spop)
		if not tc:IsType(TYPE_EFFECT) then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_ADD_TYPE)
			e2:SetValue(TYPE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2,true)
		end
	end
end