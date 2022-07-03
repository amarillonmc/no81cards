--机械加工 螳螂
if not pcall(function() require("expansions/script/c40008000") end) then require("script/c40008000") end
local m,cm=rscf.DefineCard(40009434)
local m=40009434
local cm=_G["c"..m]
cm.named_with_Machining=1
function cm.Machining(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Machining
end
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,cm.lfilter,1,1)  
end
function cm.lfilter(c)
	return not c:IsLinkCode(m) and c:IsLinkRace(RACE_INSECT)
end
