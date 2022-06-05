--万•杀•狱
local cm,m,o=GetID()
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.con1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
end
function cm.conf1(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x5fd5)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.conf1,tp,LOCATION_MZONE,0,1,nil)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(cm.op1con)
	e1:SetOperation(cm.op1op)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.op1con(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsRelateToEffect(re) and re:IsActiveType(TYPE_MONSTER) and (re:GetHandler():IsOnField() or re:GetHandler():IsLocation(LOCATION_HAND))
end
function cm.op1op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(eg,REASON_EFFECT)
end