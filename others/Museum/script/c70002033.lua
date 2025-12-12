--儚有火木
local m=70002033
local cm=_G["c"..m]
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.condition)
	e1:SetCost(cm.cost)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_END
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.lpcon1)
	e1:SetOperation(cm.lpop1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	--sp_summon effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(cm.regcon)
	e2:SetOperation(cm.regop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetCondition(cm.lpcon2)
	e3:SetOperation(cm.lpop2)
	e3:SetLabelObject(e2)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCountLimit(1)
	e4:SetCondition(cm.damcon)
	e4:SetOperation(cm.damop)
	e4:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e4,tp)
end
function cm.cfilter(c,sp)
	return c:IsType(TYPE_EFFECT)
		and c:IsSummonPlayer(sp) and c:IsFaceup()
end
function cm.lpcon1(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return eg:IsExists(cm.cfilter,1,nil,1-tp)
		and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2 or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE))
		and not Duel.IsChainSolving()
end
function cm.lpop1(e,tp,eg,ep,ev,re,r,rp)
	local lg=eg:Filter(cm.cfilter,nil,1-tp)
	local rnum=lg:GetSum(Card.GetAttack)
	if Duel.Damage(1-tp,rnum,REASON_EFFECT)<1 then return end
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return eg:IsExists(cm.cfilter,1,nil,1-tp)
		and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2 or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE))
		and Duel.IsChainSolving()
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local lg=eg:Filter(cm.cfilter,nil,1-tp)
	local g=e:GetLabelObject()
	if g==nil or #g==0 then
		lg:KeepAlive()
		e:SetLabelObject(lg)
	else
		g:Merge(lg)
	end
	Duel.RegisterFlagEffect(tp,m+1,RESET_CHAIN,0,1)
end
function cm.lpcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,m+1)>0
end
function cm.lpop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.ResetFlagEffect(tp,m+1)
	local lg=e:GetLabelObject():GetLabelObject()
	lg=lg:Filter(Card.IsLocation,nil,LOCATION_MZONE)
	local rnum=lg:GetSum(Card.GetAttack)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e:GetLabelObject():SetLabelObject(g)
	lg:DeleteGroup()
	if Duel.Damage(1-tp,rnum,REASON_EFFECT)<1 then return end
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
end
function cm.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,m)<1
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	return Duel.SetLP(tp,math.ceil(Duel.GetLP(tp)/2))
end
