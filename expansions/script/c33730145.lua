--[[
键★LB令 - 见见新人！
K.E.Y L.B.O - Let's Meet a Transfer Member!
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	c:Activation()
	--All FIRE "K.E.Y" monsters gain 100 ATK/DEF.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(s.target)
	e1:SetValue(100)
	c:RegisterEffect(e1)
	e1:UpdateDefenseClone(c)
	--The Attribute of all "K.E.Y" monsters you control and in your GY is also treated as FIRE.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_ADD_ATTRIBUTE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,ARCHE_KEY))
	e2:SetValue(ATTRIBUTE_FIRE)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetTargetRange(LOCATION_GRAVE,0)
	e3:SetCondition(s.gravecon)
	c:RegisterEffect(e3)
end
--E1
function s.target(e,c)
	return c:IsSetCard(ARCHE_KEY) and c:IsAttribute(ATTRIBUTE_FIRE)
end

--E3
function s.gravecon(e)
	local tp=e:GetHandlerPlayer()
	return not Duel.IsPlayerAffectedByEffect(tp,EFFECT_NECRO_VALLEY)
end