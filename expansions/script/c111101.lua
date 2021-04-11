--不准甲板着
local m=111101
local cm=_G["c"..m]
function cm.initial_effect(c)
   --link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,cm.mfilter,2,2)
end
function cm.mfilter(c)
	return not c:GetSummonLocation()==LOCATION_DECK and c:IsSummonType(SUMMON_TYPE_SPECIAL)
end