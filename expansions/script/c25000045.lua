--爬虫型异生兽 理扎理阿苏古罗拉
if not pcall(function() require("expansions/script/c25000033") end) then require("script/c25000033") end
local m,cm=rscf.DefineCard(25000045)
function cm.initial_effect(c)
	rssb.LinkSummonFun(c,3) 
	local e1=rsef.QO(c,nil,{m,0},{1,m},"des,dam","tg",LOCATION_MZONE,nil,rssb.rmtdcost(1),rstg.target({Card.IsFaceup,"des",0,LOCATION_MZONE},rsop.list(nil,"dam",0,1000)),cm.desop)
	local e2=rsef.STO(c,EVENT_LEAVE_FIELD,{m,1},{1,m+100},"sp","de,dsp",rssb.lfucon,nil,rsop.target(rssb.ssfilter(true),"sp",LOCATION_REMOVED),cm.spop)
end
function cm.desop(e,tp)
	local tc=rscf.GetTargetCard()
	if tc and Duel.Destroy(tc,REASON_EFFECT)>0 then
		Duel.Damage(1-tp,1000,REASON_EFFECT)
	end
end
function cm.spop(e,tp)
	local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_REMOVED,0,nil)
	if #g>0 then
		Duel.ConfirmCards(1-tp,g)
		rsop.SelectSpecialSummon(tp,rssb.ssfilter(true),tp,LOCATION_REMOVED,0,1,1,nil,{},e,tp)
	end 
end