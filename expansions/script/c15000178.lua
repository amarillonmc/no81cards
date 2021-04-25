local m=15000178
local cm=_G["c"..m]
cm.name="黑翼的奇术师"
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,cm.matfilter,1,1)
	c:EnableReviveLimit()
end
function cm.matfilter(c)
	return c:IsLinkAbove(3) and c:IsLinkMarker(LINK_MARKER_BOTTOM) --bit.band(c:GetLinkMarker(),LINK_MARKER_BOTTOM)~=0
end