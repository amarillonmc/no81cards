--文明审判者 吉尔巴利斯
if not pcall(function() require("expansions/script/c25010000") end) then require("script/c25010000") end
local m,cm=rscf.DefineCard(25000091)
function cm.initial_effect(c)   
	rscf.SetSummonCondition(c,false,aux.linklimit)
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_MACHINE),3)   
	local e1=rsef.SV_IMMUNE_EFFECT(c,cm.val)
	local e2=rsef.SV_INDESTRUCTABLE(c,"battle")
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=rsef.QO(c,nil,{m,0},1,"rm,dam",nil,LOCATION_MZONE,nil,rscost.cost(Card.IsAbleToRemoveAsCost,"rm",LOCATION_GRAVE),rsop.target(cm.rmfilter,"rm",0,LOCATION_GRAVE+LOCATION_MZONE,true),cm.rmop)
	local e5=rsef.QO(c,nil,{m,3},{1,m},"td",nil,LOCATION_MZONE,nil,nil,rsop.target(aux.TRUE,"tg",LOCATION_REMOVED),cm.tgop)
	local e6=rsef.QO(c,nil,{m,4},{1,m},"sp",nil,LOCATION_MZONE,nil,nil,rsop.target(cm.spfilter,"sp",LOCATION_GRAVE),cm.spop)
end
function cm.spfilter(c,e,tp)
	return c:IsCode(m-1,m-2) and rscf.spfilter2()(c,e,tp)
end
function cm.spop(e,tp)
	rsop.SelectSpecialSummon(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,{},e,tp)
end
function cm.tgop(e,tp)
	rsop.SelectToGrave(tp,aux.TRUE,tp,LOCATION_REMOVED,0,1,3,nil,{ REASON_EFFECT+REASON_RETURN })
end
function cm.val(e,re)
	return rsval.imntg2(e,re) and re:IsActiveType(TYPE_MONSTER)
end
function cm.rmfilter(c)
	return c:IsAbleToRemove() and c:IsType(TYPE_MONSTER)
end 
function cm.rmop(e,tp)
	local g1=Duel.GetMatchingGroup(cm.rmfilter,tp,0,LOCATION_MZONE,nil)
	local g2=Duel.GetMatchingGroup(cm.rmfilter,tp,0,LOCATION_GRAVE,nil)
	if #g1<=0 and #g2<=0 then return end
	local op=rsop.SelectOption(tp,#g1>0,{m,1},#g2>0,{m,2})
	local ct=0
	if op==1 then
		ct=Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)
	else
		ct=Duel.Remove(g2,POS_FACEUP,REASON_EFFECT)
	end
	Duel.Damage(1-tp,ct*500,REASON_EFFECT)
end