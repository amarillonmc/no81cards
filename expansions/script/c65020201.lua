--虚拟水神之月
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(65020201,"VrAqua")
if rsvraq then return end
rsva=cm
rscf.DefineSet(rsva,"VrAqua")
function rsva.filter_l(c)
	return c:IsLevel(10)
end
function rsva.filter_ar(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_CYBERSE)
end
function rsva.filter_al(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsLevel(10)
end
function rsva.filter_rl(c)
	return c:IsRace(RACE_CYBERSE) and c:IsLevel(10)
end
function rsva.filter_rl2(c)
	return c:IsRace(RACE_CYBERSE) and c:IsLevel(4)
end
function rsva.filter_a(c)
	return c:IsAttribute(ATTRIBUTE_WATER) 
end
function rsva.Summon(tp,checkhint,isbreak,filter)
	rsop.SelectOC(checkhint and {m,2} or nil,isbreak)
	return rsop.SelectSolve(HINTMSG_SUMMON,tp,cm.sumfilter(filter),tp,LOCATION_HAND,0,1,1,nil,cm.sumfun,tp)
end
function cm.sumfilter(filter)
	return function(c,tp)
		return (not filter or filter(c,tp)) and c:IsSummonable(true,nil)
	end
end
function cm.sumfun(g,tp)
	local tc=g:GetFirst()
	Duel.Summon(tp,tc,true,nil)
	return true
end
function rsva.MonsterEffect(c,code,op)
	local e1=rsef.STO(c,EVENT_SUMMON_SUCCESS,{m,3},{1,code},"se,th","de,dsp",nil,nil,rsop.target(cm.sfthfilter,"th",LOCATION_DECK),cm.sfthop)
	local e2=rsef.RegisterClone(c,e1,"code",EVENT_FLIP)
	local e3=rsef.QO(c,nil,{m,4},{1,code},"sum",nil,LOCATION_MZONE,nil,rscost.cost(Card.IsAbleToHandAsCost,"th"),rsop.target(cm.mesumfilter,"sum",LOCATION_HAND),cm.mesumop(op))
	return e1,e2,e3
end
function cm.sfthfilter(c)
	return c:IsAbleToHand() and (rsva.IsSetST(c) or rsva.filter_al(c))
end
function cm.sfthop(e,tp)
	rsop.SelectToHand(tp,cm.sfthfilter,tp,LOCATION_DECK,0,1,1,nil,{})
end
function cm.mesumfilter(c)
	return c:IsRace(RACE_CYBERSE) and c:IsSummonable(true,nil)
end
function cm.mesumop(op)
	return function(e,tp,...)
		if op then op(e,tp,...) end
		rsva.Summon(tp,false,false,cm.mesumfilter)
	end
end
-----------------------------
function cm.initial_effect(c)
	local e1=rsef.ACT(c,nil,nil,{1,m},"se,th",nil,nil,nil,rsop.target(cm.thfilter,"th",LOCATION_DECK),cm.act)
	local e2=rsef.I(c,{m,0},{1,m+100},"td,dr","tg",LOCATION_GRAVE,nil,aux.bfgcost,rstg.target({cm.tdfilter,"td",LOCATION_GRAVE,0,1,3,c},rsop.list(1,"dr",1)),cm.tdop)
end
function cm.thfilter(c)
	return ((c:IsLevelBelow(4) and rsva.filter_ar(c)) or (c:IsType(TYPE_TRAP) and rsva.IsSet(c))) and c:IsAbleToHand()
end
function cm.act(e,tp)
	rsop.SelectToHand(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,{})
end
function cm.tdfilter(c)
	return rsva.IsSet(c) and c:IsAbleToDeck()
end
function cm.tdop(e,tp)
	local tg=rsgf.GetTargetGroup()
	if #tg>0 and Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)>0 then
		local og=Duel.GetOperatedGroup()
		if not og:IsExists(Card.IsLocation,1,nil,rsloc.de) then return end
		if og:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then
			Duel.ShuffleDeck(tp)
		end
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end