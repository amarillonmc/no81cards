--圣殿英雄 堕世之魂
function c16362026.initial_effect(c)
	c:EnableCounterPermit(0xdc1)
	c:SetCounterLimit(0xdc1,3)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(c16362026.counter)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,16362026)
	e3:SetCondition(c16362026.damcon)
	e3:SetCost(c16362026.damcost)
	e3:SetTarget(c16362026.damtg)
	e3:SetOperation(c16362026.damop)
	c:RegisterEffect(e3)
	--destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,16362126)
	e4:SetTarget(c16362026.reptg)
	e4:SetValue(c16362026.repval)
	e4:SetOperation(c16362026.repop)
	c:RegisterEffect(e4)
end
function c16362026.cfilter(c)
	return c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c16362026.counter(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(c16362026.cfilter,nil)
	if ct>0 then
		e:GetHandler():AddCounter(0xdc1,ct,true)
	end
end
function c16362026.damcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=eg:GetFirst()
	return ep~=tp and rc:IsControler(tp) and rc:IsSetCard(0xdc0)
end
function c16362026.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0xdc1,1,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0xdc1,1,REASON_COST)
end
function c16362026.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(ev)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ev)
end
function c16362026.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c16362026.repfilter(c,tp)
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0xdc0) and c:IsControler(tp)
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c16362026.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c16362026.repfilter,1,nil,tp)
		and Duel.IsCanRemoveCounter(tp,1,0,0xdc1,1,REASON_EFFECT) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c16362026.repval(e,c)
	return c16362026.repfilter(c,e:GetHandlerPlayer())
end
function c16362026.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RemoveCounter(tp,1,0,0xdc1,1,REASON_EFFECT)
end