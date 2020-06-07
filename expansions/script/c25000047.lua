--赤色的死之巨人 黑暗浮士德
if not pcall(function() require("expansions/script/c25000033") end) then require("script/c25000033") end
local m,cm=rscf.DefineCard(25000047)
function cm.initial_effect(c)
	rssb.LinkSummonFun(c,2) 
	local e1=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{m,0},{1,m},nil,"de,dsp",rscon.sumtype("link"),nil,rsop.target(cm.actfilter,nil,LOCATION_DECK),cm.actop)
	local e2=rsef.I(c,{m,1},{1,m+100},"des","tg",LOCATION_MZONE,nil,rssb.rmtdcost(1),rstg.target(aux.FilterBoolFunction(Card.IsType,TYPE_SPELL+TYPE_TRAP),"des",0,LOCATION_ONFIELD),cm.desop)
	local e3=rsef.STO(c,EVENT_LEAVE_FIELD,{m,2},{1,m+200},"th,ga","de,dsp",rssb.lfucon,nil,rsop.target(cm.thfilter,"th",LOCATION_GRAVE),cm.thop)
end
function cm.actfilter(c,e,tp)
	return c:IsCode(25000050) and c:GetActivateEffect() and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function cm.actop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,cm.actfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if not tc then return end
	local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	if fc then
		Duel.SendtoGrave(fc,REASON_RULE)
		Duel.BreakEffect()
	end
	Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
	local te=tc:GetActivateEffect()
	te:UseCountLimit(tp,1)
	local tep=tc:GetControler()
	local cost=te:GetCost()
	if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
	Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
end
function cm.desop(e,tp)
	local tc=rscf.GetTargetCard()
	Duel.Destroy(tc,REASON_EFFECT)
end
function cm.thfilter(c)
	return rssb.IsSetM(c) and c:IsAbleToHand()
end 
function cm.thop(e,tp)
	rsop.SelectToHand(tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_GRAVE,0,1,1,nil,{})
end