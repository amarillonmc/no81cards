--以斯拉的斥候 乌兹
if not pcall(function() require("expansions/script/c65011001") end) then require("script/c65011001") end
local m,cm=rscf.DefineCard(65011009,"Israel")
function cm.initial_effect(c)
	local e1=rsef.I(c,"tg",{1,m},"tg",nil,LOCATION_HAND,nil,rscost.cost(0,"dish"),rsop.target(cm.tgfilter,"tg",LOCATION_DECK),cm.tgop)
	local e2=rsef.I(c,"tg",{1,m},"tg,sp","tg",LOCATION_GRAVE,nil,nil,rstg.target({cm.tgfilter2,"tg",0,LOCATION_ONFIELD },rsop.list(rsisr.spfilter,"sp")),cm.tgop2)
	local e3=rsef.RegisterOPTurn(c,e2,rsisr.exlcon)
end
function cm.tgfilter(c)
	return c:IsAbleToGrave() and rsisr.IsSet(c)
end 
function cm.tgop(e,tp)
	rsop.SelectToGrave(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil,{})
end
function cm.tgfilter2(c)
	return c:IsAbleToGrave() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.tgop2(e,tp)
	local tc=rscf.GetTargetCard()
	if rsisr.spops(e,tp)>0 and tc then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end