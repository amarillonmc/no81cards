--唤士的相遇
if not pcall(function() require("expansions/script/c130005101") end) then require("script/c130005101") end
local m,cm=rscf.DefineCard(130005116,"DragonCaller")
function cm.initial_effect(c)
	local e1=rsdc.HandActFun(c)
	local e2=rsef.ACT(c,nil,nil,{1,m,1},"se,th,sp",nil,nil,rscost.cost(1,"dish"),rsop.target({rscf.spfilter2(Card.IsCode,130005101),"sp",rsloc.hd},{cm.thfilter,"th",rsloc.dg}),cm.act)
end
function cm.thfilter(c)
	return c:IsAbleToHand() and rsdc.IsSetM(c)
end
function cm.act(e,tp)
	if rsop.SelectSpecialSummon(tp,rscf.spfilter2(Card.IsCode,130005101),tp,rsloc.hd,0,1,1,nil,{},e,tp)>0 then
		rsop.SelectOC(nil,true)
		rsop.SelectToHand(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,{})
	end
end
