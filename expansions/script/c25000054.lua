--颚门龙 闪耀进化
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(25000054)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcMixRep(c,true,true,aux.FilterBoolFunction(Card.IsRace,RACE_WARRIOR),1,1,aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_LIGHT),aux.FilterBoolFunction(Card.IsFusionType,TYPE_NORMAL))
	aux.AddContactFusionProcedure(c,Card.IsReleasable,LOCATION_MZONE,0,Duel.Release,REASON_COST)
	local e1=rsef.QO(c,EVENT_CHAINING,{m,0},{1,m},"neg","dsp,dcal",LOCATION_MZONE,rscon.negcon(4,true),nil,rstg.negtg(),cm.negop)
	local e2=rsef.FTO(c,EVENT_PHASE+PHASE_END,{m,1},{1,m+100},"sp",nil,LOCATION_GRAVE+LOCATION_REMOVED,rscon.turns,nil,rsop.target(rscf.spfilter2(),"sp"),cm.spop)
	local e4=rsef.RegisterClone(c,e2,"code",EVENT_PHASE+PHASE_STANDBY)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	e3:SetValue(cm.splimit)
	c:RegisterEffect(e3)
end
function cm.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.NegateActivation(ev) then return end
	local rc=re:GetHandler()
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e1:SetTarget(cm.distg)
	e1:SetLabelObject(rc)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetCondition(cm.discon)
	e2:SetOperation(cm.disop)
	e2:SetLabelObject(rc)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function cm.distg(e,c)
	local tc=e:GetLabelObject()
	return c:IsCode(tc:GetCode())
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:GetHandler():IsCode(tc:GetCode())
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function cm.spop(e,tp)
	local c=aux.ExceptThisCard(e)
	if not c or rssf.SpecialSummon(c)<=0 then return end
	Duel.RegisterFlagEffect(tp,m,0,0,1)
	local ct=Duel.GetFlagEffect(tp,m)
	local e1=rscf.QuickBuff({c,nil,true},"atk+,def+",500*ct)
end
