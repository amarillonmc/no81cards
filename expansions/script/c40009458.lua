--古代龙 喧嚣尾羽龙
if not pcall(function() require("expansions/script/c40009451") end) then require("script/c40009451") end
local m,cm = rscf.DefineCard(40009458)
function cm.initial_effect(c)
	local e1=rsad.RitualFun(c)
	local e2=rsad.TributeSFun2(c,m,"se,th",nil,rsop.target(cm.thfilter,nil,rsloc.dg),cm.thop)
	local e3=rsad.TributeTFun(c,m,"res","de",rsop.target(Card.IsReleasable,"res",LOCATION_DECK,0,2),cm.resop)
end
function cm.thfilter(c)
	return c:IsAbleToHand() and ((aux.IsCodeListed(c,40009452) and c:IsType(TYPE_SPELL+TYPE_TRAP)) or c:IsCode(40009452)) 
end
function cm.thop(e,tp)
	rsop.SelectToHand(tp,aux.NecroValleyFilter(cm.thfilter),tp,rsloc.dg,0,1,1,nil,{})
end
function cm.resop(e,tp)
	local g=Duel.GetDecktopGroup(tp,2)
	if #g<2 then return end
	Duel.SendtoGrave(g,REASON_EFFECT+REASON_RELEASE)
end