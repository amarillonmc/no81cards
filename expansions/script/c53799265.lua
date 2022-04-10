local m=53799265
local cm=_G["c"..m]
cm.name="宇宙救济神"
function cm.initial_effect(c)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e2:SetCondition(cm.condition)
	e2:SetValue(499)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCondition(cm.condition)
	e3:SetTarget(function(e,c)return c==e:GetHandler():GetBattleTarget()end)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function cm.condition(e)
	return e:GetHandler():IsAttack(50)
end
