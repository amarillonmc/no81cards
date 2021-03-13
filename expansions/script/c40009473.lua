--龙血师团-渊阶
if not pcall(function() require("expansions/script/c40009469") end) then require("script/c40009469") end
local m,cm = rscf.DefineCard(40009473)
function cm.initial_effect(c)
	local e1,e2,e3 = rsdb.XyzFun(c,m,m-1)
	local e4 = rsdb.ImmueFun(c,m)
	local e5 = rsef.I(c,"th",nil,"th,sp",nil,LOCATION_MZONE,nil,rscost.rmxyz(1),rsop.target(cm.thfilter,"th",LOCATION_GRAVE),cm.thop)
end
function cm.thfilter(c)
	return c:IsSetCard(0x3f1b) and c:IsAbleToHand()
end
function cm.thop(e,tp)
	local ct,og,tc = rsop.SelectToHand(tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_GRAVE,0,1,1,nil,{})
	if tc and tc:IsLocation(LOCATION_HAND) then
		rsop.SelectOC("sp",true)
		rsop.SelectSpecialSummon(tp,rscf.spfilter2(Card.IsRace,RACE_DRAGON),tp,LOCATION_HAND,0,1,1,nil,{},e,tp)
	end
end
