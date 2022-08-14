local m=15004014
local cm=_G["c"..m]
cm.name="原始使臣 阿努纳奇"
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,cm.matfilter,1,1)
	c:EnableReviveLimit()
end
function cm.matfilter(c)
	return c:IsLinkCode(27204312)
end