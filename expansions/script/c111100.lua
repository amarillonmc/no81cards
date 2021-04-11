--可以推甲板人
local m=111100
local cm=_G["c"..m]
function cm.initial_effect(c)
   --link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,cm.mfilter,1,1)
end
function cm.mfilter(c)
	return c:GetSummonLocation()==LOCATION_DECK
end