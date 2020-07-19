--吴迪
local m=14010074
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--xyz summon
	aux.AddXyzProcedureLevelFree(c,cm.mfilter,nil,1,1)
end
function cm.mfilter(c,xyzc)
	return c:IsXyzType(TYPE_XYZ) and c:IsRank(4)
end