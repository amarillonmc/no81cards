--唤士的引导者-安达
if not pcall(function() require("expansions/script/c130005101") end) then require("script/c130005101") end
local m,cm=rscf.DefineCard(130005103,"DragonCaller")
function cm.initial_effect(c)
	local e1=rsef.QO(c,nil,{m,0},{1,m},"sp",nil,LOCATION_GRAVE,nil,rscost.cost(cm.resfilter,"res",LOCATION_HAND),rsop.target(rscf.spfilter2(),"sp"),cm.spop)
	local e3=rsef.STO(c,EVENT_RELEASE,{m,1},{1,m+100},"th","tg,de",nil,nil,rstg.target(cm.thfilter,"th",LOCATION_GRAVE),cm.thop)
end
function cm.resfilter(c)
	return c:IsReleasable() and c:IsType(TYPE_MONSTER) and (rsdc.IsSetM(c) or not c:IsAttribute(ATTRIBUTE_WIND))
end
function cm.spop(e,tp)
	local c=rscf.GetSelf(e)
	if c then rssf.SpecialSummon(c) end
end
function cm.thfilter(c)
	return rsdc.IsSetM(c) and c:IsAbleToHand()
end
function cm.thop(e,tp)
	local tc=rscf.GetTargetCard()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end