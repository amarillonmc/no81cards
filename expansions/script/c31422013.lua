local m=31422013
local cm=_G["c"..m]
cm.name="万感之歌于永远响起"
if not pcall(function() require("expansions/script/c31422000") end) then require("expansions/script/c31422000") end
function cm.initial_effect(c)
	Seine_wangan.equip_trap_enable(c,LOCATION_DECK)
end