local m=53713005
local cm=_G["c"..m]
cm.name="爱丽丝役 HNS"
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	SNNM.ALCYaku(c,m,4,LOCATION_EXTRA,1800,1800,RACE_WARRIOR,ATTRIBUTE_DARK)
	SNNM.AllGlobalCheck(c)
end
