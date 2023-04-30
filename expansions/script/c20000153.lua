--概念虚械 愤怒
if not pcall(function() require("expansions/script/c20000150") end) then require("script/c20000150") end
local cm,m,o=GetID()
function cm.initial_effect(c)
	local e = {fu_cim.XyzUnite(c)}
end
function cm.Add(e,tp,eg,ep,ev,re,r,rp)
	local g=fugf.Get(tp,"MS+MS")
	if #g<2 or not Duel.SelectYesNo(tp,aux.Stringid(m,0)) then return end
	Duel.BreakEffect()
	Duel.Hint(HINT_CODE,tp,m)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	g=g:Select(tp,1,1,e:GetHandler()):GetFirst()
	Duel.HintSelection(g)
	if Duel.Destroy(g,REASON_EFFECT)==0 or not g:IsType(TYPE_MONSTER) then return end
	Duel.Damage(1-tp,g:GetTextAttack()/2,REASON_EFFECT)
end