--龙血师团-流星魔公子
if not pcall(function() require("expansions/script/c40009469") end) then require("script/c40009469") end
local m,cm = rscf.DefineCard(40009478)
function cm.initial_effect(c)
	local e1,e2 = rsdb.SummonMatFun(c,m,"sp","sp,gs",cm.filter,rscf.spfilter2(),LOCATION_GRAVE,cm.spop)
end
function cm.filter(c,e,tp)
	return not c:IsCode(m) and c:IsType(TYPE_MONSTER)
end
function cm.spop(c,e,tp)
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end