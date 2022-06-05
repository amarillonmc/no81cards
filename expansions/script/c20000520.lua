--堕魔锚
local cm,m,o=GetID()
function cm.initial_effect(c)
	c:EnableCounterPermit(0xfd5)
	c:SetCounterLimit(0xfd5,3)
	c:SetUniqueOnField(1,0,m)
	aux.AddCodeList(c,m)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_DISCARD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(cm.tg3)
	e3:SetValue(cm.val3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
end
--e2
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0xfd5,1)
end
--e3
function cm.tgf3(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x3fd5)
		and c:IsOnField() and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(cm.tgf3,1,nil,tp) and c:GetCounter(0xfd5)>0 end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function cm.val3(e,c)
	return cm.tgf3(c,e:GetHandlerPlayer())
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(ep,0xfd5,1,REASON_EFFECT)
	Duel.Hint(HINT_CARD,0,m)
end
