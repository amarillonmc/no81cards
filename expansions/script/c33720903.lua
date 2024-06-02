--[[
甜蜜停机
Sweet Downtime
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	c:Activation()
	--Unaffected by other card effects while a player's LP is exactly 8000.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCondition(s.lpcon)
	e1:SetValue(s.efilter)
	c:RegisterEffect(e1)
	--While a player's LP is lower than 8000, all monsters they control lose ATK/DEF equal to half the difference. While a player's LP is higher than 8000, all monsters they control gain ATK/DEF equal to half the difference.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetCondition(aux.NOT(s.lpcon))
	e2:SetValue(s.update)
	c:RegisterEffect(e2)
	e2:UpdateDefenseClone(c)
	--While the difference between the players' LP is 4000 or more, the player with less LP cannot activate cards or effects in response to the activation of their opponent's cards and effects.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(s.diffcon)
	e3:SetOperation(s.chainop)
	c:RegisterEffect(e3)
	--While the difference between the players' LP is 8000 or more, the player with less LP cannot activate cards or effects.
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCondition(s.diffcon2)
	e4:SetTargetRange(1,0)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCondition(s.diffcon3)
	e5:SetTargetRange(0,1)
	c:RegisterEffect(e5)
end
--E1
function s.lpcon(e)
	return Duel.GetLP(0)==8000 or Duel.GetLP(1)==8000
end
function s.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end

--E2
function s.update(e,c)
	return math.floor((Duel.GetLP(c:GetControler())-8000)/2)
end

--E3
function s.diffcon()
	return math.abs(Duel.GetLP(0)-Duel.GetLP(1))>=4000
end
function s.chainop(e,tp,eg,ep,ev,re,r,rp)
	local max=math.max(Duel.GetLP(0),Duel.GetLP(1))
	local p=Duel.GetLP(0)==max and 0 or 1
	if ep==p then
		Duel.SetChainLimit(s.chainlm)
	end
end
function s.chainlm(re,rp,tp)
	return tp==rp
end

--E4
function s.diffcon2(e)
	local tp=e:GetHandlerPlayer()
	local diff=Duel.GetLP(tp)-Duel.GetLP(1-tp)
	return diff<=-8000
end
function s.diffcon3(e)
	local tp=e:GetHandlerPlayer()
	local diff=Duel.GetLP(1-tp)-Duel.GetLP(tp)
	return diff<=-8000
end