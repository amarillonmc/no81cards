--奉神天使 沙利叶
local m=20000354
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/c20000350") end) then require("script/c20000350") end
function cm.initial_effect(c)
	local e1=fs.sum(c,m,function(c)return c:IsLocation(LOCATION_ONFIELD)and c:IsAbleToHand()end,
	function(e,tp,eg,ep,ev,re,r,rp,g,fc)Duel.SendtoHand(g,nil,REASON_EFFECT)end)
end