--概念虚械 辉煌
if not pcall(function() require("expansions/script/c20000150") end) then require("script/c20000150") end
local cm,m,o=GetID()
function cm.initial_effect(c)
	local e = {fu_cim.XyzUnite(c)}
end
function cm.Add(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=fugf.GetFilter(tp,"E",{Card.IsSetCard,Card.IsType,Card.IsRankBelow,Card.IsCanOverlay},{0xcfd1,TYPE_XYZ,c:GetRank()})
	if not (c:IsRelateToEffect(e) and c:IsFaceup() and c:IsType(TYPE_XYZ) and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0))) then return end
	Duel.BreakEffect()
	Duel.Hint(HINT_CODE,tp,m)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	g=g:Select(tp,1,1,e:GetHandler())
	Duel.Overlay(c,g)
end