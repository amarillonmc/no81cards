--Re_SURGUM 白与光之殇
local m=60002045
local cm=_G["c"..m]
cm.name="Re:SURGUM 白与光之殇"
function cm.initial_effect(c)
	--cannot lose (damage)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetCondition(cm.surcon1)
	e1:SetOperation(cm.surop1)
	c:RegisterEffect(e1)
end
function cm.surcon1(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and Duel.GetLP(tp)<=0
end
function cm.surop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(tp,1)
end