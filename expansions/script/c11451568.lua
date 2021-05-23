--～关于没完成全收集就不算通关这档子事～
--21.05.20
local m=11451568
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.cost)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) and Duel.GetFlagEffect(tp,m)==0 end
	local ct=math.floor(math.min(Duel.GetLP(tp),6000)/1000)
	local t={}
	for i=1,ct do
		t[i]=i*1000
	end
	local cost=Duel.AnnounceNumber(tp,table.unpack(t))
	Duel.PayLPCost(tp,cost)
	e:SetLabel(cost)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,m)~=0 then return end
	Duel.RegisterFlagEffect(tp,m,0,0,0)
	local c=e:GetHandler()
	local val=e:GetLabel()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetLabel(2*val)
	e1:SetCondition(cm.damcon)
	e1:SetOperation(cm.damop)
	Duel.RegisterEffect(e1,tp)
	--summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(cm.spcon)
	e2:SetOperation(cm.spop)
	Duel.RegisterEffect(e2,1-tp)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	Duel.RegisterEffect(e3,1-tp)
	--count
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_ADJUST)
	e4:SetOperation(cm.adjustop)
	Duel.RegisterEffect(e4,1-tp)
	--activate
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EVENT_CHAINING)
	e5:SetOperation(cm.regop)
	Duel.RegisterEffect(e5,1-tp)
	local e6=e2:Clone()
	e6:SetCode(EVENT_CHAIN_SOLVING)
	e6:SetCondition(cm.accon)
	e6:SetOperation(cm.acop)
	Duel.RegisterEffect(e6,1-tp)
end
function cm.damcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetFirst():IsControler(1-tp) and Duel.GetAttackTarget()==nil
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.Damage(1-tp,e:GetLabel(),REASON_EFFECT)
	e:Reset()
end
function cm.spfilter(c,sp)
	return c:GetSummonPlayer()==sp
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.spfilter,1,nil,tp)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local n=eg:FilterCount(cm.spfilter,nil,tp)
	local ct=Duel.GetFlagEffectLabel(tp,m+1)
	if not ct then
		Duel.RegisterFlagEffect(tp,m+1,0,0,0,n)
	else
		Duel.SetFlagEffectLabel(tp,m+1,ct+n)
	end
	ct=Duel.GetFlagEffectLabel(tp,m+1)
	if ct==5 or ct==8 or ct==11 or ct==14 or ct==17 then
		Duel.Hint(HINT_CARD,0,m)
		Duel.Recover(tp,1500,REASON_EFFECT)
	end
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,m+3,RESET_CHAIN,0,1)
end
function cm.accon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and Duel.GetFlagEffect(tp,m+3)>0
end
function cm.acop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFlagEffectLabel(tp,m+2)
	if not ct then
		Duel.RegisterFlagEffect(tp,m+2,0,0,0,1)
	else
		Duel.SetFlagEffectLabel(tp,m+2,ct+1)
	end
	ct=Duel.GetFlagEffectLabel(tp,m+2)
	if ct==4 or ct==8 or ct==12 or ct==16 or ct==20 then
		Duel.Hint(HINT_CARD,0,m)
		Duel.Recover(tp,1500,REASON_EFFECT)
	end
end
function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)
	local lab=e:GetLabel()
	if (0xaa8-lab)&(1<<ct)~=0 then
		Duel.Hint(HINT_CARD,0,m)
		Duel.Recover(tp,1500,REASON_EFFECT)
		lab=lab|(1<<ct)
		e:SetLabel(lab)
	end
end