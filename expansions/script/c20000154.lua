--概念虚械 跃升
if not pcall(function() require("expansions/script/c20000150") end) then require("script/c20000150") end
local cm,m,o=GetID()
function cm.initial_effect(c)
	local e = {fu_cim.XyzUnite(c)}
end
function cm.Add(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsRelateToEffect(e) and c:IsFaceup() and (c:GetAttack()/2)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0))) then return end
	Duel.BreakEffect()
	Duel.Hint(HINT_CODE,tp,m)
	local atk=c:GetAttack()/2
	local e1=fuef.S(c,nil,EFFECT_UPDATE_ATTACK,nil,nil,atk,nil,nil,nil,c,RESET_EVENT+RESETS_STANDARD)
end