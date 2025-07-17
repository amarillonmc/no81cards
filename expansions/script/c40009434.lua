--机械加工 螳螂
local cm=GetID()
local m=40009434
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,cm.lfilter,1,1)  
end
function cm.lfilter(c)
	return not c:IsLinkCode(m) and c:IsLinkRace(RACE_INSECT)
end
