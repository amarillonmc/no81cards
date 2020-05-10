--超古代生物 哥尔赞
if not pcall(function() require("expansions/script/c25000024") end) then require("script/c25000024") end
local m,cm=rscf.DefineCard(25000027)
function cm.initial_effect(c)
	local e1,e2,e3=rsoc.SpSummonFun(c,m,1,"sp",nil,rsop.target(rscf.spfilter2(rsoc.IsSet),"sp",LOCATION_DECK),cm.spop)
	local e4=rsoc.TributeFun(c,m,"tg","tg",rstg.target(Card.IsAbleToGrave,"tg",0,LOCATION_MZONE),cm.tgop)
end
function cm.spop(e,tp)
	rsop.SelectSpecialSummon(tp,rscf.spfilter2(rsoc.IsSet),tp,LOCATION_DECK,0,1,1,nil,{},e,tp)
end
function cm.tgop(e,tp)
	local tc=rscf.GetTargetCard()
	if tc then Duel.SendtoGrave(tc,REASON_EFFECT) end
end
