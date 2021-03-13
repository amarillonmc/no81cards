--龙血师团-魅惑羡望
if not pcall(function() require("expansions/script/c40009469") end) then require("script/c40009469") end
local m,cm = rscf.DefineCard(40009476)
function cm.initial_effect(c)
	local e1,e2,e3 = rsdb.XyzFun(c,m,m+1)
	local e4 = rsdb.ImmueFun(c,m)
	local e5 = rsef.I(c,"con",nil,"con","tg",LOCATION_MZONE,nil,rscost.rmxyz(1),rstg.target(Card.IsControlerCanBeChanged,"con",0,LOCATION_MZONE),cm.conop)
end
function cm.conop(e,tp)
	local tc = rscf.GetTargetCard()
	if tc then Duel.GetControl(tc,tp,PHASE_END,1) end
end
