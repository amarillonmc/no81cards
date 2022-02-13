local m=15004081
local cm=_G["c"..m]
cm.name="荒仙地"
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x9f3e),6,2)
	c:EnableReviveLimit()
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_ONFIELD)
	e1:SetTarget(cm.disable)
	e1:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetTargetRange(1,1)
	e2:SetValue(cm.aclimit)
	c:RegisterEffect(e2)
end
function cm.disable(e,c)
	return e:GetHandler():GetColumnGroup():IsContains(c)
end
function cm.aclimit(e,re,tp)
	local c=re:GetHandler()
	return re:IsActivated() and e:GetHandler():GetColumnGroup():IsContains(c) and c:GetControler()~=e:GetHandler():GetControler()
end