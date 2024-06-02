--[[
【月】交织的百合 黑与白
==【Ｒ Bonding Lilies - B.W.】==
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
	--Control of this card cannot switch.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
	c:RegisterEffect(e1)
	--While your opponent controls "Bonding Lilies - W.B.", all damage both players take becomes 0, also, when a player declares an attack, they can negate it and gain LP equal to the attacking monster's ATK. Otherwise, neither player can Normal or Special Summon monsters.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CHANGE_DAMAGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,1)
	e2:SetCondition(s.econ)
	e2:SetValue(0)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(s.econ)
	e4:SetOperation(s.disop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_CANNOT_SUMMON)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,1)
	e5:SetCondition(aux.NOT(s.econ))
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	c:RegisterEffect(e6)
end

--E2
function s.econ(e)
	return Duel.IsExists(false,aux.FaceupFilter(Card.IsCode,id-1),e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
end

--E4
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	if a:IsFaceup() and a:IsRelateToBattle() and Duel.SelectYesNo(ep,aux.Stringid(id,0)) and Duel.NegateAttack() then
		Duel.Recover(ep,a:GetAttack(),REASON_EFFECT)
	end
end