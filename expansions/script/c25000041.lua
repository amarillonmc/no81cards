--隐身型异生兽 格鲁格莱姆
if not pcall(function() require("expansions/script/c25000033") end) then require("script/c25000033") end
local m,cm=rscf.DefineCard(25000041)
function cm.initial_effect(c)
	rssb.SummonCondition(c) 
	local e1=rsef.I(c,{m,0},{1,m},"sp,rm",nil,LOCATION_HAND,rssb.cfcon,nil,rsop.target({rssb.ssfilter(true),"sp",LOCATION_REMOVED},{rssb.rmfilter,"rm"}),cm.spop)
	local e2=rsef.QO(c,nil,{m,1},{1,m+100},"rm","tg",LOCATION_MZONE,rscon.phmp,rssb.rmtdcost(1),rstg.target({rssb.rmfilter,"rm",0,LOCATION_ONFIELD},rsop.list(rssb.rmfilter,"rm")),cm.rmop)
end
function cm.spop(e,tp)
	local c=aux.ExceptThisCard(e)
	local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_REMOVED,0,nil)
	if #g>0 then
		Duel.ConfirmCards(1-tp,g)
		if rsop.SelectSpecialSummon(tp,rssb.ssfilter(true),tp,LOCATION_REMOVED,0,1,1,nil,{},e,tp)>0 and c then
			Duel.Remove(c,POS_FACEDOWN,REASON_EFFECT)
		end
	end 
end
function cm.rmop(e,tp)
	local c=aux.ExceptThisCard(e)
	local tc=rscf.GetTargetCard()
	if c and tc then
		Duel.Remove(rsgf.Mix2(c,tc),POS_FACEDOWN,REASON_EFFECT)
	end
end