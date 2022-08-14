local m=25000003
local cm=_G["c"..m]
cm.name="一位青年艺术家的画像"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetOperation(cm.remain)
	c:RegisterEffect(e3)
end
function cm.remain(e,tp,eg,ep,ev,re,r,rp)
	if not re:GetHandler():IsType(TYPE_SPELL+TYPE_TRAP) or not re:GetHandler():IsLocation(LOCATION_SZONE) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_REMAIN_FIELD)
	e1:SetProperty(EFFECT_FLAG_OATH)
	re:GetHandler():RegisterEffect(e1)
	re:GetHandler():CancelToGrave()
end
