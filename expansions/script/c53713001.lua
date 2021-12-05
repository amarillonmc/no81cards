local m=53713001
local cm=_G["c"..m]
cm.name="爱丽丝役 TRS"
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	SNNM.ALCYaku(c,m,2,LOCATION_HAND,1900,300,RACE_WARRIOR,ATTRIBUTE_DARK)
	SNNM.AllGlobalCheck(c)
end
