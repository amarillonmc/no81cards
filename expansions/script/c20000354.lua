--奉神天使 沙利叶
local cm,m,o=GetID()
if not pcall(function() require("expansions/script/c20000350") end) then require("script/c20000350") end
function cm.initial_effect(c)
	local e = {fu_god.Summon(c,m,cm.filter,cm.op)}
end
function cm.filter(c)
	return c:IsLocation(LOCATION_ONFIELD)and c:IsAbleToHand()
end
function cm.op(e,tp,eg,ep,ev,re,r,rp,g,fc)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
end