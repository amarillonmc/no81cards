--猩 红 庭 院 的 狂 宴
local m=22348261
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--must attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetCode(EFFECT_MUST_ATTACK)
	c:RegisterEffect(e1)
	--extra attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c22348261.extg)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--act limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(0,1)
	e3:SetValue(1)
	e3:SetCondition(c22348261.actcon)
	c:RegisterEffect(e3)
	--atk1
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetTarget(c22348261.atktg)
	e4:SetValue(c22348261.val)
	c:RegisterEffect(e4)
end
function c22348261.extg(e,c)
	return c:IsSetCard(0xa70a)
end
function c22348261.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa70a)
end
function c22348261.actcon(e)
	local a=Duel.GetAttacker()
	local b=Duel.GetAttackTarget()
	return (a and c22348261.cfilter(a)) or (b and c22348261.cfilter(b))
end
function c22348261.atktg(e,c)
	return c:IsSetCard(0xa70a)
end
function c22348261.val(e,re,tp)
	local tp=Duel.GetTurnPlayer()
	local t1=Duel.GetBattledCount(1-tp)
	local t2=Duel.GetBattledCount(tp)
	local t=t1+t2
	return t*300
end
