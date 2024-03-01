--灰烬守护者 防火女
if not pcall(function() dofile("expansions/script/c10171001.lua") end) then dofile("script/c10171001.lua") end
local m,cm=rscf.DefineCard(10171008)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0xa335),2)
	local e2=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{m,0},{1,m},nil,"de,dsp",rscon.sumtype("link"),nil,rsop.target(cm.thfilter,nil,LOCATION_DECK),cm.actop)
	local e3=rsef.QO(c,nil,{m,1},1,nil,"tg",LOCATION_MZONE,nil,nil,rstg.target(cm.imfilter,"dum",LOCATION_MZONE),cm.imop)
end
function cm.thfilter(c,e,tp)
	return c:IsCode(m+12) and c:GetActivateEffect() and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function cm.actop(e,tp,eg,ep,ev,re,r,rp)
	rsop.SelectSolve(HINTMSG_TOFIELD,tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,cm.actfun,e,tp,eg,ep,ev,re,r,rp)
end
function cm.actfun(g,e,tp,eg,ep,ev,re,r,rp)
	local tc=g:GetFirst()
	if not tc then return end
	local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
	if fc and tc:IsType(TYPE_FIELD) then
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
	return true
end
function cm.imfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa335,0xc335)
end 
function cm.imop(e,tp)
	local c=e:GetHandler()
	local tc=rscf.GetTargetCard(Card.IsFaceup)
	if not tc then return end
	local e1,e2,e3=rsef.SV_UPDATE({c,tc},"lv,atk,def",{1,800,800},nil,rsreset.est,"cd")
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_ONFIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetTarget(cm.distg)
	e1:SetReset(rsreset.est_pend)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	tc:RegisterEffect(e1,true)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetCondition(cm.discon2)
	e2:SetOperation(cm.disop2)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
	e2:SetReset(rsreset.est_pend)
	tc:RegisterEffect(e2,true)
end
function cm.distg(e,c)
	return c:IsHasCardTarget(e:GetHandler()) 
end
function cm.discon2(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g:IsContains(e:GetHandler()) and rp~=tp
end
function cm.disop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end