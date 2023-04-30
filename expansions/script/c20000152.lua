--概念虚械 欺瞒
if not pcall(function() require("expansions/script/c20000150") end) then require("script/c20000150") end
local cm,m,o=GetID()
function cm.initial_effect(c)
	local e = {fu_cim.XyzUnite(c)}
end
function cm.Addf(c,e,tp,mc)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0xcfd1) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function cm.Add(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=fugf.GetFilter(tp,"E",cm.Addf,{e,tp,c})
	if aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) and c:IsFaceup() and c:IsRelateToEffect(e) and c:IsControler(tp) and not c:IsImmuneToEffect(e)  
		and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		if not tc then return end
		Duel.BreakEffect()
		Duel.Hint(HINT_CODE,tp,m)
		g=c:GetOverlayGroup()
		if #g~=0 then Duel.Overlay(tc,g) end
		tc:SetMaterial(Group.FromCards(c))
		Duel.Overlay(tc,Group.FromCards(c))
		Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end