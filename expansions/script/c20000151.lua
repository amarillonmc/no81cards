--概念虚械 骄傲
if not pcall(function() require("expansions/script/c20000150") end) then require("script/c20000150") end
local cm,m,o=GetID()
function cm.initial_effect(c)
	local e = {fu_cim.XyzUnite(c)}
end
function cm.Add(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=fugf.GetFilter(tp,"M+M",{Card.IsAttackBelow,Card.IsFaceup},c:GetAttack(),c)
	if not (c:IsRelateToEffect(e) and not c:IsFacedown() and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0))) then return end
	Duel.BreakEffect()
	Duel.Hint(HINT_CODE,tp,m)
	Duel.Destroy(g,REASON_EFFECT)
end