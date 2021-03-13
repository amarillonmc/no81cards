--龙血师团-恶潜羡望
if not pcall(function() require("expansions/script/c40009469") end) then require("script/c40009469") end
local m,cm = rscf.DefineCard(40009477)
function cm.initial_effect(c)
	local e1,e2 = rsdb.SummonMatFun(c,m,"th","se,th",cm.filter,Card.IsAbleToHand,LOCATION_DECK,cm.thop)
end
function cm.filter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and not c:IsCode(m) 
end
function cm.thop(c,e,tp)
	rsop.SendtoHand(c,nil,REASON_EFFECT)
end