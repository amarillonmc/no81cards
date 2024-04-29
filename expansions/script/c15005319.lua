local m=15005319
local cm=_G["c"..m]
cm.name="机皇兵 机录三型"
function cm.initial_effect(c)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(cm.val)
	c:RegisterEffect(e1)
	--ind
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
function cm.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x13)
end
function cm.val(e,c)
	return Duel.GetMatchingGroupCount(cm.atkfilter,0,LOCATION_MZONE,LOCATION_MZONE,c)*100
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_SPELL+TYPE_TRAP))
	e2:SetCountLimit(1)
	e2:SetValue(cm.valcon)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function cm.valcon(e,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0 and rp==1-e:GetHandlerPlayer()
end