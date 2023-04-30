--概念虚械 执法
if not pcall(function() require("expansions/script/c20000150") end) then require("script/c20000150") end
local cm,m,o=GetID()
function cm.initial_effect(c)
	local e = {fu_cim.XyzUnite(c)}
end
function cm.Add(e,tp,eg,ep,ev,re,r,rp)
	local g=fugf.GetFilter(tp,"+M",Card.IsControlerCanBeChanged)
	if #g==0 or not Duel.SelectYesNo(tp,aux.Stringid(m,0)) then return end
	Duel.BreakEffect()
	Duel.Hint(HINT_CODE,tp,m)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	g=g:Select(tp,1,1,nil)
	Duel.HintSelection(g)
	Duel.GetControl(g:GetFirst(),tp)
	local e1=fuef.S(e,nil,EFFECT_CANNOT_ATTACK,nil,nil,nil,nil,nil,nil,g,RESET_EVENT+RESETS_STANDARD)
end