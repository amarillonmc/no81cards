local m=11638007
local cm=_G["c"..m]
cm.name="No空手道，No忍者！"
function cm.initial_effect(c)
	aux.AddCodeList(c,11638001)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--Destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(cm.reptg)
	e2:SetValue(cm.repval)
	c:RegisterEffect(e2)
end
function cm.filter1(c)
	return c:IsFaceup() and c:IsCode(11638001)
end
function cm.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0x2b)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCondition(cm.nbcon)
	e3:SetTarget(aux.TargetBoolFunction(cm.filter1))
	e3:SetValue(cm.efilter)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetCondition(cm.bcon)
	e4:SetTarget(aux.TargetBoolFunction(cm.filter2))
	e4:SetValue(cm.e2filter)
	e4:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e4,tp)
end
function cm.nbcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return not (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
end
function cm.bcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
end
function cm.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:GetHandler():IsType(TYPE_MONSTER) and te:GetHandler():IsSetCard(0x2b)
end
function cm.e2filter(e,te,c)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:GetHandler():IsType(TYPE_MONSTER) --and te:IsActiveType(TYPE_MONSTER) and te:GetOwner()~=c
end
function cm.repfilter(c,tp)
	return c:IsLocation(LOCATION_ONFIELD) and c:IsCode(11638001) and c:IsControler(tp) and c:IsFaceup() and c:GetReasonEffect() and (c:GetReasonEffect():IsActiveType(TYPE_SPELL) or c:GetReasonEffect():IsActiveType(TYPE_TRAP))
		and c:IsReason(REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() and eg:IsExists(cm.repfilter,1,nil,tp) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
		return true
	else return false end
end
function cm.repval(e,c)
	return cm.repfilter(c,e:GetHandlerPlayer())
end