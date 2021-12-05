local m=53799085
local cm=_G["c"..m]
cm.name="控制管控"
function cm.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e0:SetCost(cm.cost)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(cm.tfcon)
	e1:SetCost(cm.tfcost)
	e1:SetTarget(cm.tftg)
	e1:SetOperation(cm.tfop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e2)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_CHAIN_SOLVING)
	e5:SetRange(LOCATION_SZONE)
	e5:SetOperation(cm.disop)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_IMMUNE_EFFECT)
	e6:SetRange(LOCATION_SZONE)
	e6:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e6:SetTarget(cm.etarget)
	e6:SetValue(cm.efilter)
	c:RegisterEffect(e6)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:GetHandler():IsStatus(STATUS_ACT_FROM_HAND) then
		Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
	end
end
function cm.tfcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and re:GetHandler()~=e:GetHandler()
end
function cm.tfcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end
function cm.tffilter(c)
	return c:IsCode(m) and not c:IsForbidden()
end
function cm.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tffilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>-1 end
end
function cm.tfop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,cm.tffilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,nil):GetFirst()
	if tc then Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) end
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_CHAIN_END)
	e3:SetCountLimit(1)
	e3:SetOperation(cm.op)
	Duel.RegisterEffect(e3,tp)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsOnField() then return end
	Duel.SendtoGrave(c,REASON_EFFECT)
end
function cm.cfilter(c,seq2)
	local seq1=aux.MZoneSequence(c:GetSequence())
	return c:IsFaceup() and c:IsCode(m) and seq1==seq2
end
cm[0]=0
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local loc,seq,id=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE,CHAININFO_CHAIN_ID)
	seq=aux.MZoneSequence(seq)
	if id~=cm[0] and re:IsActiveType(TYPE_MONSTER) and loc==LOCATION_MZONE and not Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_SZONE,0,1,nil,seq) then
		cm[0]=id
		Duel.Hint(HINT_CARD,0,m)
		Duel.NegateEffect(ev)
	end
end
function cm.etarget(e,c)
	return e:GetHandler():GetColumnGroup():IsContains(c)
end
function cm.efilter(e,te)
	if not te:IsActivated() then return false end
	if not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return not g or not g:IsContains(e:GetHandler())
end
