--幻层驱动 壳层
if not pcall(function() require("expansions/script/c10130001") end) then require("script/c10130001") end
local m=10130003
local cm=_G["c"..m]
function cm.initial_effect(c)
	rsqd.SetCode(c)
	local e1=rsqd.FlipFun(c,m,"des",rsop.target(aux.TRUE,"des",LOCATION_ONFIELD,LOCATION_ONFIELD),cm.op)
	local e2=rsef.FTO(c,10130001,{m,1},{1,m+100},nil,"de,dsp",LOCATION_HAND,cm.actcon,rscost.cost(Card.IsDiscardable,"dish"),rsop.target(cm.actfilter,nil,LOCATION_DECK),cm.actop)
	cm.QuantumDriver_EffectList={e1,e2}
end
function cm.op(e,tp)
	rsof.SelectHint(tp,"des")
	local dg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if #dg>0 then
		Duel.HintSelection(dg)
		Duel.Destroy(dg,REASON_EFFECT)
	end
end
function cm.actcon(e,tp,eg)
	return eg:IsExists(Card.IsControler,1,nil,tp)
end
function cm.actfilter(c,e,tp)
	return c:IsType(TYPE_CONTINUOUS) and c:IsSetCard(0xa336) and c:GetActivateEffect():IsActivatable(tp)
end
function cm.actop(e,tp)
	rsof.SelectHint(tp,rshint.act)
	local tc=Duel.SelectMatchingCard(tp,cm.actfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if not tc then return end
	Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	local te=tc:GetActivateEffect()
	local tep=tc:GetControler()
	local cost=te:GetCost()
	if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
end