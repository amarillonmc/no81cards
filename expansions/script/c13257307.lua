--超时空武装 主武-旋风镭射
local m=13257307
local cm=_G["c"..m]
if not tama then xpcall(function() dofile("expansions/script/tama.lua") end,function() dofile("script/tama.lua") end) end
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--equip limit
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_EQUIP_LIMIT)
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e11:SetValue(cm.eqlimit)
	c:RegisterEffect(e11)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(300)
	c:RegisterEffect(e1)
	--actlimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(0,1)
	e3:SetValue(cm.aclimit)
	e3:SetCondition(cm.actcon)
	c:RegisterEffect(e3)
	--pierce
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_PIERCE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(cm.target)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,0))
	e5:SetCategory(CATEGORY_ATKCHANGE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(cm.atkcon)
	e5:SetOperation(cm.atkop)
	c:RegisterEffect(e5)
	
end
function cm.eqlimit(e,c)
	return not c:GetEquipGroup():IsExists(Card.IsSetCard,1,e:GetHandler(),0x3352)
end
function cm.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function cm.actcon(e)
	local f=tama.cosmicFighters_equipGetFormation(e:GetHandler())
	return f and ((Duel.GetAttacker() and f:IsContains(Duel.GetAttacker())) or (Duel.GetAttackTarget() and f:IsContains(Duel.GetAttackTarget())))
end
function cm.target(e,c)
	local f=tama.cosmicFighters_equipGetFormation(e:GetHandler())
	return f and f:IsContains(c)
end
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttackTarget()
	local f=tama.cosmicFighters_equipGetFormation(e:GetHandler())
	return f and Duel.GetAttacker() and f:IsContains(Duel.GetAttacker()) and tc and tc:IsFaceup() and tc:IsControler(1-tp)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	local tc=Duel.GetAttackTarget()
	if ec and tc and ec:IsFaceup() and tc:IsFaceup() then
		local val=math.min(tc:GetAttack(),tc:GetDefense())
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(val)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL)
		ec:RegisterEffect(e1)
	end
end
