--特务忍兽 白鼬
local m=40010517
local cm=_G["c"..m]
cm.named_with_SpecialStealthBeast=1
function cm.SpecialStealthBeast(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_SpecialStealthBeast
end
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTarget(cm.atktg)
	e1:SetValue(500)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetTarget(cm.atktg)
	e2:SetValue(500)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(cm.eftg)
	e3:SetLabelObject(e1)
	c:RegisterEffect(e3)   
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(cm.eftg)
	e4:SetLabelObject(e2)
	c:RegisterEffect(e4) 
end
function cm.atktg(e,c)
	return cm.SpecialStealthBeast(c) 
end
function cm.eftg(e,c)
	return cm.SpecialStealthBeast(c) and c:IsType(TYPE_MONSTER) and not c:IsCode(m)
end