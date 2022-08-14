local m=25000009
local cm=_G["c"..m]
cm.name="饥饿艺术家"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
end
