--紧急弹射
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(10174036)
function cm.initial_effect(c)
	local e1=rsef.ACT(c,nil,nil,{1,m},"sp",nil,cm.con,nil,rsop.target(rscf.spfilter2(),"sp",LOCATION_HAND),cm.act)
	local e2=rsef.I(c,{m,0},{1,m+100},"th","tg",LOCATION_GRAVE,nil,nil,rstg.target({cm.thfilter,"th",LOCATION_MZONE },rsop.list(Card.IsAbleToHand,"th")),cm.thop)
end
function cm.con(e,tp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function cm.act(e,tp)
	rshint.Select(tp,"sp")
	local sg=Duel.SelectMatchingCard(tp,rscf.spfilter(),tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if #sg>0 then
		rssf.SpecialSummon(sg)
	end
end
function cm.thfilter(c)
	return c:IsAbleToHand() and c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function cm.thop(e,tp)
	local c,tc=aux.ExceptThisCard(e),rscf.GetTargetCard()
	if not tc or not c then return end
	Duel.SendtoHand(rsgf.Mix2(c,tc),nil,REASON_EFFECT)
end