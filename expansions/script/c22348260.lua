--血 月 映 照 的 红 色 庭 院
local m=22348260
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk1
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c22348260.atktg1)
	e2:SetValue(400)
	c:RegisterEffect(e2)
	--atk2
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c22348260.atktg2)
	e3:SetValue(400)
	c:RegisterEffect(e3)
	--indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetTarget(c22348260.indtg)
	e4:SetValue(c22348260.indct)
	c:RegisterEffect(e4)
	--doub
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_BATTLED)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCondition(c22348260.doubcon)
	e5:SetOperation(c22348260.doubop)
	c:RegisterEffect(e5)
	--recover
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCode(EVENT_BATTLE_DAMAGE)
	e6:SetCondition(c22348260.reccon)
	e6:SetOperation(c22348260.recop)
	c:RegisterEffect(e6)
	
end
function c22348260.atktg1(e,c)
	return c:IsSetCard(0x370a)
end
function c22348260.atktg2(e,c)
	return c:IsRace(RACE_ZOMBIE)
end
function c22348260.indtg(e,c)
	return c:IsSetCard(0x370a)
end
function c22348260.indct(e,re,r,rp)
	if bit.band(r,REASON_BATTLE)~=0 then
		return 1
	else return 0 end
end
function c22348260.doubcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local b=Duel.GetAttackTarget()
	return (a:IsSetCard(0x370a) and a:IsControler(tp) and not a:IsDualState() and a:IsType(TYPE_DUAL))
	or (b and b:IsSetCard(0x370a) and b:IsControler(tp) and not b:IsDualState() and b:IsType(TYPE_DUAL))
end
function c22348260.doubop(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_CARD,0,22348260)
	local a=Duel.GetAttacker()
	local b=Duel.GetAttackTarget()
	if a:IsSetCard(0x370a) and a:IsControler(tp) and not a:IsDualState() and a:IsType(TYPE_DUAL) then
	local e1=Effect.CreateEffect(a)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DUAL_STATUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	a:RegisterEffect(e1)
	end
	if b and b:IsSetCard(0x370a) and b:IsControler(tp) and not b:IsDualState() and b:IsType(TYPE_DUAL) then
	local e2=Effect.CreateEffect(b)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DUAL_STATUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	b:RegisterEffect(e2)
	end
end
function c22348260.reccon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and eg:GetFirst():IsControler(tp) and eg:GetFirst():IsSetCard(0x370a) 
end
function c22348260.recop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,22348260)
	Duel.Recover(tp,ev,REASON_EFFECT)
end







