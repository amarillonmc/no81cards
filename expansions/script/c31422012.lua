local m=31422012
local cm=_G["c"..m]
cm.name="万感之歌于天空响起"
if not pcall(function() require("expansions/script/c31422000") end) then require("expansions/script/c31422000") end
function cm.initial_effect(c)
	Seine_wangan.equip_trap_enable(c,LOCATION_ONFIELD)
end