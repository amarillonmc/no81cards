--死寂温迪戈·伊塔库亚
if not pcall(function() require("expansions/script/c114500") end) then require("script/c114500") end
local m,cm = rscf.DefineCard(114513)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunFun(c,cm.ffilter,aux.FilterBoolFunction(Card.IsFusionType,TYPE_FLIP),2,true)
	local e1 = rsef.STO(c,EVENT_SPSUMMON_SUCCESS,"dpd",{1,m},"dpd","de",rscon.sumtypes("fus"),nil,rsop.target({Card.IsCanTurnSet,"dpd"},{cm.cfilter,"dpd",LOCATION_MZONE,LOCATION_MZONE,2,2,c}),cm.posop)
	local e2 = rsef.QO(c,EVENT_CHAINING,"sp",{1,m+100},"sp","dsp,sa",LOCATION_MZONE,cm.spcon,rscost.cost(cm.dfilter,"upa"),rsop.target(cm.spfilter,"sp",rsloc.dg),cm.spop)
	local e3 = rsef.STO(c,EVENT_TO_GRAVE,"tg",{1,m+100},"tg","de",nil,nil,rsop.target(cm.tgfilter,"tg",LOCATION_DECK),cm.tgop)
end
function cm.tgfilter(c)
	return c:IsSetCard(0xca4) and c:IsAbleToGrave()
end
function cm.tgop(e,tp)
	rsop.SelectToGrave(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil,{})
end
function cm.dfilter(c)
	return c:IsFacedown()
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0xca4) and rscf.spfilter2()(c,e,tp)
end
function cm.spop(e,tp)
	rsop.SelectSpecialSummon(tp,aux.NecroValleyFilter(cm.spfilter),tp,rsloc.dg,0,1,1,nil,{},e,tp)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_FLIP)
end
function cm.ffilter(c)
	return c:IsFusionType(TYPE_EFFECT) and c:IsOnField()
end
function cm.cfilter(c)
	return c:IsCanTurnSet() and c:IsControler(Duel.GetTurnPlayer())
end
function cm.posop(e,tp)
	local c = rscf.GetFaceUpSelf(e)
	if not c or Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE)<=0 then return end
	local p = Duel.GetTurnPlayer()
	local g = rsop.SelectSolve("dpd",p,cm.cfilter,p,LOCATION_MZONE,0,2,2,nil,{})
	if #g ~= 2 then return end
	Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
end