--[[
裂命的一划
Dreaded Stroke
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id,o=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	--Activation
	aux.AddEquipSpellEffect(c,true,true,Card.IsFaceup)
	--[[When this card becomes equipped to a monster, change that monster to Attack Position.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_EQUIP)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(s.poscon)
	e1:SetOperation(s.posop)
	c:RegisterEffect(e1)
	--[[The equipped monster gains 1500 ATK, and is unaffected by other card effects (except its own), also it cannot be destroyed by battle, but its battle position cannot be changed.]]
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(1500)
	c:RegisterEffect(e2)
	c:Unaffected(UNAFFECTED_OTHER_EQUIP)
	c:CannotBeDestroyedByBattle()
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	c:RegisterEffect(e3)
	--[[Any battle damage either player takes from battles involving the equipped monster is doubled.]]
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e4:SetValue(DOUBLE_DAMAGE)
	c:RegisterEffect(e4)
	--[[Each time the equipped monster activates its effect, inflict damage equal to the difference between its ATK and its original ATK to its controller immediately after it resolves.]]
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(aux.IsEquippedCond)
	e5:SetOperation(s.regop)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_CHAIN_SOLVED)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCondition(s.damcon)
	e6:SetOperation(s.damop)
	c:RegisterEffect(e6)
end

local FLAG_TRACK_CHAIN = id

--E1
function s.poscon(e,tp,eg,ev,ep,re,r,rp)
	local c=e:GetHandler()
	return eg:IsContains(c)
end
function s.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	if ec:IsFaceup() and not ec:IsAttackPos() and ec:IsCanChangePosition() then
		Duel.ChangePosition(ec,POS_FACEUP_ATTACK)
	end
end

--E5
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if not re:IsActiveType(TYPE_MONSTER) or not rc or rc~=c:GetEquipTarget() then return end
	c:RegisterFlagEffect(FLAG_TRACK_CHAIN,RESET_EVENT|RESETS_STANDARD_FACEDOWN|RESET_CHAIN,0,1)
end
--E6
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	if not ec then return false end
	local rc=re:GetHandler()
	return c:GetFlagEffect(FLAG_TRACK_CHAIN)~=0 and re:IsActiveType(TYPE_MONSTER) and rc and rc==ec
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	local val=math.abs(ec:GetAttack()-ec:GetBaseAttack())
	if val>0 then
		Duel.Hint(HINT_CARD,0,id)
		Duel.Damage(ec:GetControler(),val,REASON_EFFECT)
	end
end