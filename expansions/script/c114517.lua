--外道降临
if not pcall(function() require("expansions/script/c114500") end) then require("script/c114500") end
local m,cm = rscf.DefineCard(114517)
function cm.initial_effect(c)
	local e1 = rsef.A(c,nil,nil,{1,m},"sp","tg",nil,nil,rstg.target2(cm.fun,cm.cfilter,"dum",LOCATION_MZONE),cm.act)
	local e2 = rsef.I(c,"sset",{1,m},"sset",nil,LOCATION_GRAVE,nil,aux.bfgcost,rsop.target(cm.setfilter,"sset",LOCATION_DECK),cm.setop)
end
function cm.setfilter(c)
	return c:IsSetCard(0xca4) and c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function cm.setop(e,tp)
	rsop.SelectSSet(tp,cm.setfilter,tp,LOCATION_DECK,0,1,1,nil,{})
end
function cm.fun(g,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.cfilter(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_FLIP) and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c)
end
function cm.spfilter(c,e,tp,tc)
	return c:IsSetCard(0xca4) and rscf.spfilter2()(c,e,tp) and not tc:IsCode(c:GetCode()) and not tc:IsAttribute(c:GetAttribute())
end
function cm.act(e,tp)
	local tc = rscf.GetTargetCard(Card.IsFaceup)
	if not tc then return end
	rsop.SelectSpecialSummon(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,{},e,tp,tc)
end