--钢铁的兄弟 詹奈
if not pcall(function() require("expansions/script/c25010000") end) then require("script/c25010000") end
local m,cm=rscf.DefineCard(25000097)
function cm.initial_effect(c)  
	local e1=rsef.QO(c,nil,{m,0},{1,m},"sp",nil,LOCATION_HAND,nil,rscost.cost(Card.IsAbleToDeckAsCost,"td"),rsop.target(rscf.spfilter2(Card.IsCode,m-1),"sp",LOCATION_DECK),cm.spop)
	local e2=rsef.QO(c,nil,{m,1},{1,m+100},"td,se,th",nil,LOCATION_MZONE,nil,rscost.cost(cm.tdfilter,{"td",cm.fun},rsloc.hog+LOCATION_REMOVED),rsop.target(Card.IsAbleToDeck,"td",LOCATION_ONFIELD,LOCATION_ONFIELD,1,2,c),cm.tdop)
	--rsef.SV_CANNOT_DISABLE_S(c)
end
function cm.spop(e,tp)
	rsop.SelectSpecialSummon(tp,rscf.spfilter2(Card.IsCode,m-1),tp,LOCATION_DECK,0,1,1,nil,{},e,tp)
end
function cm.tdfilter(c,e,tp)
	return c:IsAbleToDeckAsCost() and (not c:IsLocation(LOCATION_REMOVED) or c:IsFaceup()) and (c:IsRace(RACE_MACHINE) or c:IsType(TYPE_SPELL+TYPE_TRAP)) and e:GetHandler():IsAbleToDeckAsCost()
end
function cm.fun(g,e,tp)
	g:AddCard(e:GetHandler())
	return g,Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function cm.thfilter(c)
	return c:IsAbleToHand() and c:IsCode(m,m-1)
end
function cm.tdop(e,tp)
	if rsop.SelectToDeck(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,2,nil,{})>0 then
		rsop.SelectOC({m,2},true)
		rsop.SelectToHand(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,{})
	end
end