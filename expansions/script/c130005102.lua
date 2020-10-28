--唤士的观测者-尤拉
if not pcall(function() require("expansions/script/c130005101") end) then require("script/c130005101") end
local m,cm=rscf.DefineCard(130005102,"DragonCaller")
function cm.initial_effect(c)
	local e1=rsef.SV_CANNOT_BE_TARGET(c,"effect",aux.tgoval)
	local e2=rsef.QO(c,nil,{m,0},{1,m},"sp",nil,LOCATION_HAND,nil,rscost.cost(Card.IsDiscardable,"dish",LOCATION_HAND,0,1,1,c),rsop.target({rscf.spfilter2(),"sp"},{cm.spfilter,"sp",LOCATION_DECK }),cm.spop)
	local e3=rsef.STO(c,EVENT_RELEASE,{m,1},{1,m+100},"sp","tg,de",nil,nil,rstg.target(rscf.spfilter2(rsdc.IsSetM),"sp",LOCATION_GRAVE),cm.spop2)
end
function cm.spfilter(c,e,tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>=2 and rsdc.IsSetM(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.spop(e,tp)
	local c=rscf.GetSelf(e)
	if c and rssf.SpecialSummon(c)>0 then
		rsop.SelectOC(nil,true)
		rsop.SelectSpecialSummon(tp,rscf.spfilter2(rsdc.IsSetM),tp,LOCATION_DECK,0,1,1,nil,{},e,tp)
	end
end
function cm.spop2(e,tp)
	local tc=rscf.GetTargetCard()
	if tc then rssf.SpecialSummon(tc) end
end
