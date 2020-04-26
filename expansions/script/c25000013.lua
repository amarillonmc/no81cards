--斯菲亚之眼
if not pcall(function() require("expansions/script/c25000011") end) then require("script/c25000011") end
local m,cm=rscf.DefineCard(25000013,nil)
function cm.initial_effect(c)
	local e1=rsef.ACT(c,nil,nil,{1,m},"tg,se,th","tg",nil,nil,rstg.target(cm.tgfilter,"tg",LOCATION_MZONE),cm.tgop)
	local e3=rsef.I(c,{m,3},{1,m+100},"sp","tg",LOCATION_GRAVE,aux.exccon,aux.bfgcost,rstg.target(rscf.spfilter2(rsgs.isfus),"sp",LOCATION_GRAVE),cm.spop)
end
function cm.tgfilter(c,e,tp)
	return c:IsAbleToGrave() and rsgs.isfusf(c)
end
function cm.tgop(e,tp)
	local tc=rscf.GetTargetCard()
	if not tc or Duel.SendtoGrave(tc,REASON_EFFECT)<=0 or not tc:IsLocation(LOCATION_GRAVE) then return end
	local g1=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)
	local g2=Duel.GetMatchingGroup(cm.tdfilter,tp,LOCATION_DECK,0,nil)
	if #g1<=0 and #g2<=0 then return end
	local opt=rsop.SelectOption(tp,true,{m,1},#g1>0,{m,2},#g2>0,{m,0},true)
	if opt==1 then return end
	Duel.BreakEffect()
	local sg=opt==2 and g1 or g2
	local fun=opt==2 and rsgf.SelectToHand or rsgf.SelectToGrave
	fun(sg,tp,aux.TRUE,1,1,nil,{})
end
function cm.thfilter(c)
	return c:IsLevel(1) and c:IsAbleToHand()
end
function cm.tdfilter(c)
	return c:IsLevel(1) and c:IsAbleToGrave()
end
function cm.spop(e,tp)
	local tc=rscf.GetTargetCard()
	if tc then rssf.SpecialSummon(tc) end
end