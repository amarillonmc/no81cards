--灰烬修女 芙莉德
if not pcall(function() require("expansions/script/c10171001") end) then require("script/c10171001") end
local m,cm=rscf.DefineCard(10171003)
function cm.initial_effect(c)
	local e1,e2=rsds.SearchFun(c,m+10)
	local e3=rsds.ChainingFun(c,m,"des","tg",rstg.target(aux.TRUE,"des",LOCATION_ONFIELD,LOCATION_ONFIELD),cm.desop)
end
function cm.desop(e,tp)
	local tc=rscf.GetTargetCard()
	if tc then Duel.Destroy(tc,REASON_EFFECT) end
end
