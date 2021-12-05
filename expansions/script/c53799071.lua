local m=53799071
local cm=_G["c"..m]
cm.name="无面剪刀 833"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetValue(cm.limit)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetCode(EFFECT_ADD_TYPE)
	e2:SetTarget(cm.tg)
	e2:SetValue(TYPE_TUNER)
	c:RegisterEffect(e2)
end
function cm.limit(e,c)
	if not c then return false end
	return c:IsLink(2)
end
function cm.tg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c) and not c:IsLevel(0)
end
