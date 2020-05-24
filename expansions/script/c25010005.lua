--光之巨人 奇迹戴拿
if not pcall(function() require("expansions/script/c25010001") end) then require("script/c25010001") end
local m,cm=rscf.DefineCard(25010005)
function cm.initial_effect(c)
	rsgol.TigaSummonFun(c,m,m-1,0,rscon.turns)
	local e1=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{m,0},{1,m},"se,th","de,dsp",nil,rscost.cost(Card.IsAbleToDeckAsCost,"td",LOCATION_HAND,0,3),rsop.target(cm.thfilter,"th",LOCATION_DECK),cm.thop)
end
function cm.thfilter(c)
	return c:IsAbleToHand() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.thop(e,tp)
	rsop.SelectToHand(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,{})
end