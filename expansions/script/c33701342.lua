--切蒲英炮
local m=33701342
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.condition)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	if not cm.global_check then
		cm.global_check=true
		cm[0]=0
		cm[1]=0
		cm[2]=0
		cm[3]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DAMAGE)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_RECOVER)
		ge2:SetOperation(cm.checkop1)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge3:SetOperation(cm.clear)
		Duel.RegisterEffect(ge3,0)
	end
	
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and not Duel.CheckPhaseActivity()
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetOperation(cm.operation)
	e1:SetReset(RESET_PHASE+PHASE_END,1)
	Duel.RegisterEffect(e1,tp)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local lp1=Duel.GetLP(tp)
	local lp2=Duel.GetLP(1-tp)
	local op=0
	if lp1<lp2 then op=0
	elseif lp1>lp2 then op=1
	else op=2
	end
	if op==0 then
		Duel.Damage(1-tp,cm[tp],REASON_EFFECT,true)
	elseif op==1 then
		Duel.Recover(tp,cm[tp],REASON_EFFECT,true)
	else
		Duel.Damage(tp,3000,REASON_EFFECT,true)
		Duel.Damage(1-tp,3000,REASON_EFFECT,true)
		Duel.RDComplete()
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	cm[ep]=cm[ep]+ev
end
function cm.checkop1(e,tp,eg,ep,ev,re,r,rp)
	cm[ep+2]=cm[ep+2]+2
end
function cm.clear(e,tp,eg,ep,ev,re,r,rp)
	cm[0]=0
	cm[1]=0
	cm[2]=0
	cm[3]=0
end
