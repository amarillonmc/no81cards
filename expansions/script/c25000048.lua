--漆黑之恶魔 黑暗梅菲斯特
if not pcall(function() require("expansions/script/c25000033") end) then require("script/c25000033") end
local m,cm=rscf.DefineCard(25000048)
function cm.initial_effect(c)
	rssb.LinkSummonFun(c,3) 
	local e1=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{m,0},{1,m},"se,th","de,dsp",rscon.sumtype("link"),nil,rsop.target(cm.actfilter,nil,LOCATION_DECK),cm.actop)
	local e2=rsef.QO(c,nil,{m,3},{1,m+100},"rm",nil,LOCATION_MZONE,nil,rssb.rmtdcost(1),rsop.target(rssb.rmfilter,"rm",0,LOCATION_GRAVE),cm.rmop)
	local e3=rsef.STO(c,EVENT_LEAVE_FIELD,{m,0},{1,m+200},"se,th","de,dsp",rssb.lfucon,nil,rsop.target(cm.thfilter,nil,LOCATION_DECK),cm.thop)
end
function cm.actfilter(c,e,tp)
	return c:IsCode(25000050) and ((c:GetActivateEffect() and c:GetActivateEffect():IsActivatable(tp,true,true)) or (c:IsAbleToHand()))
end
function cm.actop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,cm.actfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if not tc then return end
	local b1=tc:IsAbleToHand()
	local b2=tc:GetActivateEffect() and tc:GetActivateEffect():IsActivatable(tp,true,true)
	local op=rsop.SelectOption(tp,b1,{m,1},b2,{m,2})
	if op==1 then
		rsop.SendtoHand(tc)
	else
		local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		te:UseCountLimit(tp,1,true)
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
	end
end
function cm.rmop(e,tp)
	rsop.SelectRemove(tp,aux.NecroValleyFilter(rssb.rmfilter),tp,0,LOCATION_GRAVE,1,1,nil,{POS_FACEDOWN,REASON_EFFECT })
end
function cm.thfilter(c)
	return c:IsCode(25000051) and c:IsAbleToHand()
end
function cm.thop(e,tp)
	rsop.SelectToHand(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,{})
end