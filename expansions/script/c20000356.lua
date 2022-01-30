--奉神天使 乌列尔
local m=20000356
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/c20000350") end) then require("script/c20000350") end
function cm.initial_effect(c)
	local e1=fs.sum(c,m,function(c)return c:IsLocation(LOCATION_GRAVE)and c:IsAbleToHand()end,
	function(e,tp,eg,ep,ev,re,r,rp,g,fc)Duel.SendtoHand(g,tp,REASON_EFFECT)end)
end