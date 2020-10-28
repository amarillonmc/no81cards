--唤士的序章
if not pcall(function() require("expansions/script/c130005101") end) then require("script/c130005101") end
local m,cm=rscf.DefineCard(130005115,"DragonCaller")
function cm.initial_effect(c)
	local e1=rsdc.HandActFun(c)
	local e2=rsef.ACT(c,nil,nil,{1,m,1},"se,th",nil,nil,nil,rsop.target(cm.thfilter,"th",rsloc.dg),cm.act)
end
function cm.thfilter(c)
	return c:IsAbleToHand() and rsdc.IsSet(c)
end
function cm.act(e,tp)
	rsop.SelectToHand(tp,aux.NecroValleyFilter(cm.thfilter),tp,rsloc.dg,0,1,1,nil,{})
end
