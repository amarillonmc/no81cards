--机械加工 马蜂
if not pcall(function() require("expansions/script/c40008000") end) then require("script/c40008000") end
local m,cm=rscf.DefineCard(40009429)
function cm.initial_effect(c)
	local e1 = rsef.SV_CHANGE(c,"type",TYPE_NORMAL+TYPE_MONSTER)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	local e2 = rsef.I(c,"th",{1,m},"th",nil,LOCATION_HAND,nil,rscost.cost(0,"dish"),rsop.target(cm.thfilter,"th",LOCATION_GRAVE),cm.thop)
end
function cm.thfilter(c)
	return c:IsAbleToHand() and c:IsType(TYPE_NORMAL) and not c:IsCode(m)
end
function cm.gcheck(g)
	return #g == 1 or (g:GetClassCount(Card.GetCode) == #g and g:FilterCount(Card.IsSetCard,nil,0x5f1d) == #g)
end
function cm.thop(e,tp)
	local g = Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_GRAVE,0,nil)
	if #g <= 0 then return end
	rshint.Select(tp,"th")
	local tg = g:SelectSubGroup(tp,cm.gcheck,false,1,2)
	Duel.HintSelection(tg)
	Duel.SendtoHand(tg,nil,REASON_EFFECT)
end
