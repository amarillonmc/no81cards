--熔岩谷剑士
function c98920653.initial_effect(c)
	 --link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkAttribute,ATTRIBUTE_FIRE),2,2)
	c:EnableReviveLimit()
	--atk/def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_FIRE))
	e1:SetValue(500)
	c:RegisterEffect(e1) 
	--atk2
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c98920653.indtg)
	e2:SetValue(500)
	c:RegisterEffect(e2)
	--indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(c98920653.indtg1)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	 --pierce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_PIERCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c98920653.indtg1)
	c:RegisterEffect(e2)
end
function c98920653.indtg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c) and c:IsAttribute(ATTRIBUTE_FIRE)
end
function c98920653.indtg1(e,tc)
	local c=e:GetHandler()
	return tc==c or (c:GetLinkedGroup():IsContains(tc) and tc:IsAttribute(ATTRIBUTE_FIRE))
end