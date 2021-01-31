--宇宙重置机器 葛洛卡•主教
if not pcall(function() require("expansions/script/c25010000") end) then require("script/c25010000") end
local m,cm=rscf.DefineCard(25000071)
function cm.initial_effect(c)
	rscf.SetSummonCondition(c,false,aux.linklimit)
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_MACHINE),3)
	local e1=rsef.SV_CANNOT_BE_TARGET(c,"effect",aux.tgoval)
	local e2=rsef.SV_INDESTRUCTABLE(c,"effect",aux.indoval)
	local e3=rsef.QO(c,EVENT_CHAINING,{m,0},1,"dam","ptg",LOCATION_MZONE,cm.con,cm.cost,rsop.target(1500,"dam",0,1),cm.op)
	local e4=rsef.QO(c,nil,{m,1},{1,m},"se,th",nil,LOCATION_MZONE,nil,nil,rsop.target(cm.thfilter,"th",LOCATION_DECK),cm.thop)
	local e5=rsef.QO(c,nil,{m,2},{1,m},"sp",nil,LOCATION_MZONE,nil,nil,rsop.target(cm.spfilter,"sp",LOCATION_EXTRA),cm.spop)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainNegatable(ev) and rp~=tp and re:GetHandler():IsRelateToEffect(re) and re:GetHandler():IsAbleToRemoveAsCost()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST,nil)
	Duel.NegateActivation(ev)
	Duel.Remove(re:GetHandler(),POS_FACEUP,REASON_COST)
end
function cm.op(e,tp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function cm.thfilter(c)
	return c:IsAbleToHand() and c:IsCode(25000072)
end
function cm.thop(e,tp)
	rsop.SelectToHand(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,{})
end
function cm.spfilter(c,e,tp)
	return c:IsCode(m-1,m-2) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_LMATERIAL)
end
function cm.spop(e,tp)
	rsop.SelectSpecialSummon(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,{SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP,nil,{"mat",Group.CreateGroup(),"cp"}},e,tp)
end