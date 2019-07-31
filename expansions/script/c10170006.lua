--虹色·蓝波兔
if not pcall(function() require("expansions/script/c10170001") end) then require("script/c10170001") end
local m=10170006
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLevel,1),1)
	local e1=rssp.LinkCopyFun(c)
	local e2=rssp.ChangeOperationFun2(c,m,false,aux.TRUE,cm.op)
end
function cm.op(e,tp)
	local e1,e2=rsef.FV_CANNOT_DISABLE({e:GetHandler(),tp},"dise,act")
	e1:SetReset(rsreset.pend)
	e2:SetReset(rsreset.pend)
end