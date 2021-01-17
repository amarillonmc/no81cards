--人理之基 清姬·转身
function c22020120.initial_effect(c)
	c:EnableReviveLimit()
	--attack cost
	local e103=Effect.CreateEffect(c)
	e103:SetType(EFFECT_TYPE_SINGLE)
	e103:SetCode(EFFECT_ATTACK_COST)
	e103:SetOperation(c22020120.atop)
	c:RegisterEffect(e103)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c22020120.splimit)
	c:RegisterEffect(e1)
	--attack all
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ATTACK_ALL)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--pierce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_PIERCE)
	e3:SetValue(DOUBLE_DAMAGE)
	c:RegisterEffect(e3)
end
function c22020120.atop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	Debug.Message("不会让你逃走的．．．")
	Duel.RegisterEffect(e1,tp)
end
function c22020120.splimit(e,se,sp,st)
	local sc=se:GetHandler()
	return sc and sc:IsCode(22020110)
end