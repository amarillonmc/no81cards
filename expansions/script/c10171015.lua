--法兰老狼
if not pcall(function() require("expansions/script/c10171001") end) then require("script/c10171001") end
local m,cm=rscf.DefineCard(10171015)
function cm.initial_effect(c)
	local e1=rsds.TributeFun(c,m,"se,th",nil,rsop.target(cm.thfilter,"th",LOCATION_DECK),cm.thop,true)
	local e2=rsds.SpExtraFun(c,m,m-10,m-6,nil,3)   
end
function cm.thfilter(c)
	return c:IsSetCard(0xa335) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.thop(e,tp)
	rsop.SelectToHand(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,{})
end