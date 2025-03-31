--叱影军-唯影闪
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(130001244)
function cm.initial_effect(c)
	local e1=rsef.ACT(c,nil,nil,nil,"dis,sp","tg",nil,nil,rstg.target({aux.disfilter1,"dis",0,rsloc.og},rsop.list(cm.spfilter,"sp",rsloc.hd)),cm.act)
	local e2=rsef.STO(c,EVENT_DESTROYED,{m,0},nil,"des,sp","de,dsp",cm.descon,nil,rsop.target2(cm.fun,cm.desfilter,"des",LOCATION_ONFIELD,LOCATION_ONFIELD),cm.desop)
	if cm.switch then return end
	cm.switch=true  
	local ge1=rsef.FC({c,0},EVENT_CHAINING)
	ge1:SetOperation(cm.regop)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if loc & LOCATION_HAND ~=0 then
		Duel.RegisterFlagEffect(rp,m,rsreset.pend,0,1)
	end
end
function cm.spfilter(c,e,tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsSetCard(0x852) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (Duel.GetFlagEffect(1-tp,m)>0 or c:IsLocation(LOCATION_HAND))
end
function cm.act(e,tp)
	local tc=rscf.GetTargetCard()
	local c=e:GetHandler()
	if not tc then return end
	--Duel.NegateRelatedChain(tc,RESET_TURN_SET)
	--local e1,e2=rscf.QuickBuff({c,tc},"dis,dise")
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(cm.distg)
	e1:SetLabelObject(tc)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetCondition(cm.discon)
	e2:SetOperation(cm.disop)
	e2:SetLabelObject(tc)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	--if tc:IsImmuneToEffect(e1) then return end
	rsop.SelectSpecialSummon(tp,cm.spfilter,tp,rsloc.hd,0,1,1,nil,{},e,tp)
end
function cm.distg(e,c)
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function cm.descon(e)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function cm.fun(g,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.desfilter(c,e,tp)
	return Duel.IsExistingMatchingCard(cm.spfilter2,tp,LOCATION_DECK,0,1,nil,c,e,tp)
end
function cm.spfilter2(c,rc,e,tp)
	return c:IsSetCard(0x852) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and ((rc and Duel.GetMZoneCount(tp,rc,tp)>0) or (not rc and Duel.GetLocationCount(tp,LOCATION_MZONE)>0))
end
function cm.desop(e,tp)
	local g1=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local g2=Duel.GetMatchingGroup(cm.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,e,tp)
	local dg=#g2>0 and g2 or g1
	if rsgf.SelectDestroy(dg,tp,aux.TRUE,1,1,nil)>0 then
		rsop.SelectSpecialSummon(tp,cm.spfilter2,tp,LOCATION_DECK,0,1,1,nil,{},nil,e,tp)
	end
end