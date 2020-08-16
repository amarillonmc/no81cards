local m=31480006
local cm=_G["c"..m]
cm.name="神欲下仆的气息"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.actcon)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(1,1)
	e2:SetValue(cm.aclimit)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SSET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetOperation(cm.aclimset)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_MOVE)
	e4:SetOperation(cm.op)
	c:RegisterEffect(e4)
end
function cm.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsSetCard,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil,0x1313)
end
function cm.aclimit(e,re,tp)
	if Duel.IsExistingMatchingCard(Card.IsSetCard,re:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil,0x1313) then return false end
	if not re:IsHasType(EFFECT_TYPE_ACTIVATE) or not re:IsActiveType(TYPE_SPELL) then return false end
	local c=re:GetHandler()
	return not c:IsLocation(LOCATION_SZONE) or c:GetFlagEffect(m)>0
end
function cm.aclimset(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,1)
		tc=eg:GetNext()
	end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsPreviousLocation(LOCATION_GRAVE) and not c:IsLocation(LOCATION_HAND) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		local lp=Duel.GetLP(c:GetControler())
		Duel.SetLP(c:GetControler(),lp-500)
	end
end