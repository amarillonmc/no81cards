--龙血师团-深阶
if not pcall(function() require("expansions/script/c40009469") end) then require("script/c40009469") end
local m,cm = rscf.DefineCard(40009472)
function cm.initial_effect(c)
	local e1,e2 = rsdb.SummonMatFun(c,m,"th","se,th",aux.FilterBoolFunction(Card.IsType,TYPE_SPELL+TYPE_TRAP),Card.IsAbleToHand,LOCATION_DECK,cm.thop)
end
function cm.thop(c,e,tp)
	rsop.SendtoHand(c,nil,REASON_EFFECT)
end