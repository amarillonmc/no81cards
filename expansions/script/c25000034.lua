--昆虫型异生兽 拜格巴尊
if not pcall(function() require("expansions/script/c25000033") end) then require("script/c25000033") end
local m,cm=rscf.DefineCard(25000034)
function cm.initial_effect(c)
	rssb.SummonCondition(c)  
	local e1=rsef.I(c,{m,0},{1,m},"sp",nil,LOCATION_HAND,nil,rscost.cost(rssb.rmcfilter,"rm_d",LOCATION_HAND,0,1,1,c),rssb.sstg,rssb.ssop)
	local e2=rsef.QO(c,nil,{m,1},nil,"sp",nil,LOCATION_MZONE,rscon.phmp,rscost.releaseself(true),rsop.target(rssb.ssfilter(),"sp",LOCATION_REMOVED),cm.spop)
end
function cm.spop(e,tp)
	local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_REMOVED,0,nil)
	if #g>0 then
		Duel.ConfirmCards(1-tp,g)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			rsop.SelectSpecialSummon(tp,rssb.ssfilter(true),tp,LOCATION_REMOVED,0,1,1,nil,{},e,tp)
		end
	end 
end