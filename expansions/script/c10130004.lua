--幻层驱动 硬化层
if not pcall(function() require("expansions/script/c10130001") end) then require("script/c10130001") end
local m=10130004
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=rsqd.FlipFun(c,m,"atk,def,dis",rsop.target(cm.disfilter,"dis",LOCATION_MZONE,LOCATION_ONFIELD),cm.op)
	local e2=rsef.FTO(c,EVENT_FLIP,{m,1},{1,m+100},"sp","de,dsp",LOCATION_HAND,cm.setcon,rscost.cost(Card.IsDiscardable,"dish"),rsop.target(cm.setfilter,nil,LOCATION_DECK),cm.setop)
	cm.QuantumDriver_EffectList={e1,e2}
end
function cm.disfilter(c)
	return c:IsFaceup() and not (c:IsAttack(0) and c:IsDefense(0) and c:IsDisabled())
end
function cm.op(e,tp)
	local c=e:GetHandler()
	rsof.SelectHint(tp,"dis")
	local tc=Duel.SelectMatchingCard(tp,cm.disfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
	if not tc then return end
	Duel.HintSelection(rsgf.Mix2(tc))
	Duel.NegateRelatedChain(tc,RESET_TURN_SET)
	local e1,e2=rsef.SV_SET({c,tc},"atkf,deff",0,nil,rsreset.est,"cd")
	local e3,e4=rsef.SV_LIMIT({c,tc},"dis,dise",nil,nil,rsreset.est,"cd")
end
function cm.setcon(e,tp,eg)
	return eg:IsExists(Card.IsControler,1,nil,tp)
end
function cm.setfilter(c,e,tp)
	if not c:IsSetCard(0xa336) or c:IsCode(m) then return false end
	return rsqd.SetFilter(c,e,tp)
end
function cm.setop(e,tp)
	rsof.SelectHint(tp,HINTMSG_SET)
	local tc=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if not tc then return end
	rsqd.SetFun(tc,e,tp)
end