local m=53713003
local cm=_G["c"..m]
cm.name="爱丽丝役 TIS"
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	SNNM.ALCYaku(c,m,7,LOCATION_DECK,200,2200,RACE_WARRIOR,ATTRIBUTE_DARK)
	SNNM.AllGlobalCheck(c)
end
