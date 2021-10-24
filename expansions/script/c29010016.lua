--宛如流星
if not pcall(function() require("expansions/script/c29010000") end) then require("script/c29010000") end
local m,cm = rscf.DefineCard(29010016)
function cm.initial_effect(c)
	local e0 = rsef.SV_Card(c,"tah",1,"sr",LOCATION_HAND,cm.acon)
	local e1 = rsef.A(c,nil,"des",nil,"des",nil,nil,nil,
		rsop.target(aux.TRUE,"des",0,LOCATION_ONFIELD),cm.desop)
	local e2 = rsef.A_NegateActivation(c,"des",nil,
		aux.AND(rscon.neg("a,m",1),cm.excon))
	local e3 = rsef.A(c,EVENT_SUMMON,{m,0},nil,"diss",nil,
		cm.disscon,nil,cm.disstg,cm.dissop)
	local e4 = rsef.A(c,EVENT_SPSUMMON,{m,0},nil,"diss",nil,
		cm.disscon,nil,cm.disstg,cm.dissop)
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER)
end
function cm.acon(e)
	return Duel.IsExistingMatchingCard(cm.cfilter,0,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(cm.cfilter,1,LOCATION_MZONE,0,1,nil)
end
function cm.desop(e,tp)
	rsop.SelectOperate("des",tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil,{})
end
function cm.excon(e,tp)
	local g = Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_MZONE,0,nil)
	return g:GetClassCount(Card.GetOriginalCodeRule) >= 3
end
function cm.disscon(e,tp,eg)
	return cm.excon(e,tp) and Duel.GetCurrentChain() == 0 and eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp)
end
function cm.disstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function cm.dissop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
end