--概念虚械 惊愕
if not pcall(function() require("expansions/script/c20000150") end) then require("script/c20000150") end
local cm,m,o=GetID()
function cm.initial_effect(c)
	local e = {fu_cim.XyzUnite(c)}
end
function cm.Add(e,tp,eg,ep,ev,re,r,rp)
	local g=fugf.GetFilter(tp,"+M",Card.IsFaceup)
	if not (#g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0))) then return end
	Duel.BreakEffect()
	Duel.Hint(HINT_CODE,tp,m)
	local dg=Group.CreateGroup()
	for tc in aux.Next(g) do
		local preatk=tc:GetAttack()
		local e1=fuef.S(e,nil,EFFECT_UPDATE_ATTACK,nil,nil,-1000,nil,nil,nil,tc,RESET_EVENT+RESETS_STANDARD)
		if preatk~=0 and tc:IsAttack(0) then dg:AddCard(tc) end
	end
	Duel.Destroy(dg,REASON_EFFECT)
end