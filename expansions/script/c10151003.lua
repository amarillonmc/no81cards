--神之卡
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(10151003)
function cm.initial_effect(c)
	local e1=rsef.ACT(c,nil,nil,{1,m,1},"se,th",nil,nil,rscost.cost(Card.IsDiscardable,"dish",LOCATION_HAND),rsop.target(cm.thfilter,"th",rsloc.dg),cm.act)
	local e2=rsef.I(c,{m,0},nil,"sum",nil,LOCATION_GRAVE,nil,aux.bfgcost,rsop.target(cm.sumfilter,"sum",LOCATION_HAND),cm.sumop)
end
function cm.thfilter(c)
	return c:IsCode(10000000,10000010,10000020) and c:IsAbleToHand()
end
function cm.act(e,tp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.thfilter),tp,rsloc.dg,0,nil)
	if #g>0 then
		rshint.Select(tp,"th")  
		local tg=g:SelectSubGroup(tp,aux.dncheck,false,1,3)
		rsop.SendtoHand(tg)
	end
end
function cm.sumfilter(c)
	return (c:IsSummonable(true,nil,1) or c:IsMSetable(true,nil,1)) and c:IsRace(RACE_DIVINE)
end
function cm.sumop(e,tp,eg,ep,ev,re,r,rp)
	rshint.Select(tp,"sum")  
	local tc=Duel.SelectMatchingCard(tp,cm.sumfilter,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
	if tc then
		local s1=tc:IsSummonable(true,nil,1)
		local s2=tc:IsMSetable(true,nil,1)
		if (s1 and s2 and Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or not s2 then
			Duel.Summon(tp,tc,true,nil,1)
		else
			Duel.MSet(tp,tc,true,nil,1)
		end
	end
end
