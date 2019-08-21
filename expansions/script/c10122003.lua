--空想星界 星降平原
local m=10122003
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/c10122001") end) then require("script/c10122001") end
function cm.initial_effect(c)
	local e1=rsef.ACT(c)
	local e2=rsul.ToHandActivateEffect(c,m)
	local e3=rsef.QO(c,nil,{m,0},1,"tk,sp",nil,LOCATION_FZONE,nil,rscost.cost(cm.cfilter,"dish",LOCATION_HAND),rsul.TokenTg(2),rsul.TokenOp(nil,nil,2),rsul.hint)
end
function cm.cfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsDiscardable()
end