--红莲龙律者 爱菈
local cm,m,o=GetID()
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetCondition(cm.con1)
	e1:SetValue(cm.val1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.con2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
end
--e1
function cm.con1(e)
	return e:GetHandler():IsDefensePos()
end
function cm.val1(e,re,tp)
	return re:GetHandler():IsDefensePos()
end
--e2
function cm.con2f(c,tp)
	return c:IsControler(tp) and c:IsFaceup() and c:IsAttribute(ATTRIBUTE_FIRE)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=Duel.GetAttacker()
	local tc=Duel.GetAttackTarget()
	return c and tc and (cm.con2f(c) or cm.con2f(tc))
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end
