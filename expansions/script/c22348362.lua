--绰 影 遗 迹 的 骸 骨 高 墙
local m=22348362
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,22348362)
	e1:SetTarget(c22348362.tg)
	e1:SetOperation(c22348362.tgop)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_LEAVE_FIELD_P)
	e2:SetOperation(c22348362.checkop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCondition(c22348362.descon)
	e3:SetOperation(c22348362.desop)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--Destroy2
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_LEAVE_FIELD_P)
	e4:SetRange(LOCATION_SZONE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetOperation(c22348362.regop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(c22348362.descon)
	e5:SetOperation(c22348362.desop2)
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)
	--cannot trigger
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_TARGET)
	e6:SetCode(EFFECT_CANNOT_TRIGGER)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCondition(c22348362.ctcon)
	e6:SetTarget(c22348362.cttg)
	c:RegisterEffect(e6)
	--cannot MATERIAL
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_TARGET)
	e7:SetRange(LOCATION_SZONE)
	e7:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e7:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e7:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e7:SetCondition(c22348362.ctcon)
	e7:SetValue(c22348362.sumlimit)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e8:SetValue(c22348362.fuslimit)
	c:RegisterEffect(e8)
	local e9=e7:Clone()
	e9:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e9)
	local e10=e7:Clone()
	e10:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e10)
	--banish replace
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(22348362)
	e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e11:SetRange(LOCATION_GRAVE)
	e11:SetCountLimit(1,22349362)
	c:RegisterEffect(e11)
	
	--changeffect
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e12:SetCode(EVENT_REMOVE)
	e12:SetCondition(c22348362.cecon)
	e12:SetOperation(c22348362.ceop)
	c:RegisterEffect(e12)
	
end
function c22348362.cecon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_REPLACE) and re:IsActivated() and re:IsActiveType(TYPE_MONSTER)
		and re:GetHandler():IsSetCard(0x970a)
end
function c22348362.ceop(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	tc:RegisterFlagEffect(22348362,RESET_CHAIN,0,1,1)
end
function c22348362.sumlimit(e,c)
	if not c then return false end
	return c:GetFlagEffectLabel(22349362)
end
function c22348362.fuslimit(e,c,sumtype)
	if not c then return false end
	return c:GetFlagEffectLabel(22349362) and sumtype==SUMMON_TYPE_FUSION
end


function c22348362.ctcon(e)
	local c=e:GetHandler()
	return c:GetFlagEffectLabel(22349362)
end
function c22348362.cttg(e,c)
	return c:GetFlagEffectLabel(22349362) and c:IsFaceup()
end
function c22348362.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c22348362.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		c:SetCardTarget(tc)
	end
end
function c22348362.ctgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		c:SetCardTarget(tc)
		c:RegisterFlagEffect(22349362,RESET_EVENT+RESETS_STANDARD,0,1,1)
		tc:RegisterFlagEffect(22349362,RESET_EVENT+RESETS_STANDARD,0,1,1)
	end
end
function c22348362.checkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsDisabled() and c:GetFlagEffectLabel(22349362) then
		e:SetLabel(1)
	else e:SetLabel(0) end
end
function c22348362.cfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:GetFlagEffectLabel(22349362)
end
function c22348362.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetCardTarget()
	local tg=g:Filter(c22348362.cfilter,nil)
	if tg:GetCount()>0 then
		Duel.Destroy(tg,REASON_EFFECT)
	end
end
function c22348362.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetCardTarget()
	local cg=Group.__band(g,eg)
	if cg:IsExists(c22348362.cfilter,1,nil) and c:GetFlagEffectLabel(22349362) then
		e:SetLabel(1)
	else e:SetLabel(0) end
end
function c22348362.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetLabel()==1
end
function c22348362.desop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end

