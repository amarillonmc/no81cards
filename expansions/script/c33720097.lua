--[[
【月】虚拟主播 Ruco
【Ｒ】 VLiver Ruco
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
Duel.LoadScript("glitchylib_doublesided.lua")
function s.initial_effect(c)
	aux.AddOrigDoubleSidedType(c)
	aux.AddDoubleSidedProc(c,SIDE_REVERSE,id-1,id)
	--Negate the effects of all face-up monsters your opponent controls whose ATK is lower than this card's ATK.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetTarget(s.disable)
	c:RegisterEffect(e1)
	--All monsters your opponent controls lose 2000 ATK/DEF.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(-2000)
	c:RegisterEffect(e2)
	e2:UpdateDefenseClone(c)
	--While your opponent controls a monster whose DEF is lower than this card's DEF, this card is unaffected by your opponent's card effects.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetCondition(s.econ)
	e3:SetValue(s.eval)
	c:RegisterEffect(e3)
end
--E1
function s.disable(e,c)
	local h=e:GetHandler()
	return c:IsAttackBelow(h:GetAttack()-1) and (c:IsType(TYPE_EFFECT) or (c:GetOriginalType()&TYPE_EFFECT)==TYPE_EFFECT)
end

--E3
function s.efilter(c,def)
	return c:IsFaceup() and c:IsDefenseBelow(def)
end
function s.econ(e)
	local h=e:GetHandler()
	return h:HasDefense() and Duel.IsExists(false,s.efilter,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil,h:GetDefense()-1)
end
function s.eval(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end