--
if not pcall(function() require("expansions/script/c10170001") end) then require("script/c10170001") end
local m=10170013
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=rssp.ActivateFun(c,m,"td,th,ga","dish",cm.fun,cm.op)
end
function cm.fun(e,tp,...)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,e,tp)
	local g2=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	local b1={ "td","td",PLAYER_ALL,LOCATION_ONFIELD }
	local b2={ "th","th",PLAYER_ALL,LOCATION_GRAVE }
	return g1,g2,b1,b2
end
function cm.op(op,g,e,tp)
	if op==1 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	else
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function cm.thfilter(c)
	return c:IsAbleToHand() and not c:IsCode(m)
end