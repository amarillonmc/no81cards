--奉神天使 加百列
local m=20000351
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/c20000350") end) then require("script/c20000350") end
function cm.initial_effect(c)
	local e1=fs.sum(c,m,function(c)return c:IsLocation(LOCATION_GRAVE)and c:IsAbleToDeck()end,
	function(e,tp,eg,ep,ev,re,r,rp,g,fc)Duel.SendtoDeck(g,nil,2,REASON_EFFECT)end)
end