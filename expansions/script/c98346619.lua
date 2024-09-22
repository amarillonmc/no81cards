--女儿的加护
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE+TIMINGS_CHECK_MONSTER)
	e1:SetCondition(c98346619.actcon)
	e1:SetTarget(c98346619.acttg)
	e1:SetOperation(c98346619.activate)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_LEAVE_FIELD_P)
	e2:SetOperation(c98346619.checkop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetOperation(c98346619.desop)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_TARGET)
	e4:SetCode(EFFECT_DISABLE)
	e4:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e4)
	--attackchange
	local e5=e4:Clone()
	e5:SetCode(EFFECT_SET_ATTACK_FINAL)
	e5:SetValue(0)
	c:RegisterEffect(e5)
	--indes
	e6=e5:Clone()
	e6:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e6:SetValue(1)
	c:RegisterEffect(e6)
	--immune effect
	e7=e6:Clone()
	e7:SetCode(EFFECT_IMMUNE_EFFECT)
	e7:SetValue(c98346619.efilter)
	c:RegisterEffect(e7)
	--draw
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(id,0))
	e8:SetCategory(CATEGORY_DRAW)
	e8:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e8:SetProperty(EFFECT_FLAG_DELAY)
	e8:SetCode(EVENT_TO_GRAVE)
	e8:SetCountLimit(1,id)
	e8:SetCondition(c98346619.drcon)
	e8:SetTarget(c98346619.drtg)
	e8:SetOperation(c98346619.drop)
	c:RegisterEffect(e8)
end
function c98346619.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xaf7)
end
function c98346619.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c98346619.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c98346619.actfilter(c)
	return c:IsFaceup() and c:IsAttackPos()
end
function c98346619.acttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c98346619.actfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c98346619.actfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUPATTACK)
	Duel.SelectTarget(tp,c98346619.actfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c98346619.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		c:SetCardTarget(tc)
	end
end
function c98346619.checkop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsDisabled() then
		e:SetLabel(1)
	else e:SetLabel(0) end
end
function c98346619.desop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject():GetLabel()~=0 then return end
	local tc=e:GetHandler():GetFirstCardTarget()
	if tc and tc:IsLocation(LOCATION_MZONE) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c98346619.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c98346619.drcon(e,tp,eg,ep,ev,re,r,rp)
	local loc=e:GetHandler():GetPreviousLocation()
	return loc&(LOCATION_HAND|LOCATION_DECK)==0
end
function c98346619.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c98346619.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end