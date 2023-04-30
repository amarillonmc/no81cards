--概念虚械 复苏
if not pcall(function() require("expansions/script/c20000150") end) then require("script/c20000150") end
local cm,m,o=GetID()
function cm.initial_effect(c)
	local e = {fu_cim.XyzUnite(c)}
end
function cm.Addf(c,e,tp,code)
	return c:IsSetCard(0xcfd1) and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,SUMMON_VALUE_MONSTER_REBORN,tp,false,false)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and not c:IsCode(code)
end
function cm.Add(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=fugf.GetFilter(tp,"G",cm.Addf,{e,tp,c:GetCode()})
	if #g==0 or not Duel.SelectYesNo(tp,aux.Stringid(m,0)) then return end
	Duel.BreakEffect()
	Duel.Hint(HINT_CODE,tp,m)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	g=g:Select(tp,1,1,nil)
	Duel.SpecialSummon(g,SUMMON_VALUE_MONSTER_REBORN,tp,tp,false,false,POS_FACEUP)
end