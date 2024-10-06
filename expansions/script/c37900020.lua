--魔女转生
local m=37900020
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddRitualProcGreater2(c,cm.ritual_filter)
end
function cm.ritual_filter(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER)
end
