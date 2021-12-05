local m=53713007
local cm=_G["c"..m]
cm.name="爱丽丝役 ICG"
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	SNNM.ALCYaku(c,m,0,0,100,100,RACE_SPELLCASTER,ATTRIBUTE_LIGHT)
	SNNM.AllGlobalCheck(c)
end
