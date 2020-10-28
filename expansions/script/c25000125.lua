--圆盘生物 布里扎德
if not pcall(function() require("expansions/script/c25000119") end) then require("script/c25000119") end
local m,cm=rscf.DefineCard(25000125)
function cm.initial_effect(c)
	local e1=rsufo.ShowFun(c,m,nil,"td,rm",nil,nil,nil,rsop.target(cm.rmfilter,"rm",LOCATION_DECK),cm.op,true) 
end
function cm.rmfilter(c)
	return c:IsAbleToRemove() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.op(e,tp)
	local ct,ot,tc=rsop.SelectRemove(tp,cm.rmfilter,tp,LOCATION_DECK,0,1,1,nil,{})
	if tc and tc:IsLocation(LOCATION_REMOVED) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_SOLVING)
		e1:SetCondition(cm.chcon)
		e1:SetOperation(cm.chop)
		e1:SetLabelObject(tc)
		Duel.RegisterEffect(e1,tp)
		rsufo.ToDeck(e,true)
	end
end
function cm.chcon(e,tp,eg,ep,ev,re,r,rp)
	local code=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CODE)
	return e:GetLabelObject():IsCode(code)
end
function cm.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,cm.rep_op)
end
function cm.rep_op(e,tp,eg,ep,ev,re,r,rp)
	rshint.Card(m)
	local c=rscf.GetSelf(e)
	if c and c:IsLocation(rsloc.ho+LOCATION_DECK+LOCATION_EXTRA) then Duel.Destroy(c,REASON_EFFECT) end
end