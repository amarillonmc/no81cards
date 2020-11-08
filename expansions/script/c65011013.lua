--以斯拉的猎鹰 杰利科
if not pcall(function() require("expansions/script/c65011001") end) then require("script/c65011001") end
local m,cm=rscf.DefineCard(65011013,"Israel")
function cm.initial_effect(c)
	local e1=rsef.I(c,"tg",{1,m},"tg",nil,LOCATION_HAND,nil,rscost.cost(0,"dish"),rsop.target(cm.tgfilter,"tg",LOCATION_DECK),cm.tgop)
	local e2=rsef.I(c,"tg",{1,m},"tg,sp",nil,LOCATION_GRAVE,rscon.excard2(rsisr.IsSet,LOCATION_MZONE),nil,rsop.target({Card.IsAbleToGrave,"tg",0,LOCATION_MZONE },{rsisr.spfilter,"sp"}),cm.tgop2)
	local e3=rsef.RegisterOPTurn(c,e2,rsisr.exlcon)
end
function cm.tgfilter(c)
	return c:IsAbleToGrave() and rsisr.IsSet(c)
end 
function cm.tgop(e,tp)
	rsop.SelectToGrave(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil,{})
end
function cm.tgop2(e,tp)
	if rsisr.spops(e,tp)>0 then
		rsop.SelectToGrave(tp,Card.IsAbleToGrave,tp,0,LOCATION_MZONE,1,1,nil,{})
	end
end