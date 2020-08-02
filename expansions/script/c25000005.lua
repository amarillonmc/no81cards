--根源破灭尖兵 X沙巴加
if not pcall(function() require("expansions/script/c25000000") end) then require("script/c25000000") end
local m,cm=rscf.DefineCard(25000005)
function cm.initial_effect(c)
	local e1=rszg.XyzSumFun(c,m,4,cm.spfilter)
	local e2=rsef.QO(c,nil,{m,0},{1,m+600},"des","tg",LOCATION_MZONE,nil,rscost.rmxyz(1),rstg.target(aux.TRUE,"des",0,LOCATION_ONFIELD),cm.desop)
end
function cm.spfilter(c)
	return c:IsRank(6) and c:IsSetCard(0xaf1) 
end
function cm.desop(e,tp)
	local tc=rscf.GetTargetCard()
	if tc then Duel.Destroy(tc,REASON_EFFECT) end
end