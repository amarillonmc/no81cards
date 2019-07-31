--虹色·奇彩雀
if not pcall(function() require("expansions/script/c10170001") end) then require("script/c10170001") end
local m=10170008
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,2,cm.lcheck)
	local e1=rssp.LinkCopyFun(c)
	local e2=rssp.ChangeOperationFun2(c,m,true,aux.TRUE,cm.op,{1,m})
end
function cm.lcheck(g,lc)
	return g:IsExists(Card.IsLevel,1,nil,1)
end
function cm.op(e,tp)
	rsef.FC_AttachEffect_Repeat=true
end