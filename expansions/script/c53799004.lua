local m=53799004
local cm=_G["c"..m]
cm.name="云之裘沙"
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.imucon)
	e3:SetOperation(cm.imuop)
	c:RegisterEffect(e3)
end
function cm.imucon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and re:GetHandler()~=e:GetHandler()
end
function cm.imutg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetFlagEffect(tp,m)==0 then Duel.RegisterFlagEffect(tp,m,RESET_CHAIN,0,1) end
		local flag=Duel.GetFlagEffectLabel(tp,m)
		return bit.band(flag,0x1)==0 or bit.band(flag,0x2)==0 or bit.band(flag,0x4)==0
	end
end
function cm.imuop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetFlagEffect(tp,m)==0 then Duel.RegisterFlagEffect(tp,m,RESET_CHAIN,0,1) end
	local flag=Duel.GetFlagEffectLabel(tp,m)
	local off=1
	local ops={}
	local opval={}
	if bit.band(flag,0x1)==0 then
		ops[off]=aux.Stringid(m,0)
		opval[off-1]=1
		off=off+1
	end
	if bit.band(flag,0x2)==0 then
		ops[off]=aux.Stringid(m,1)
		opval[off-1]=2
		off=off+1
	end
	if bit.band(flag,0x4)==0 then
		ops[off]=aux.Stringid(m,2)
		opval[off-1]=3
		off=off+1
	end
	if off==1 then return end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		Duel.SetFlagEffectLabel(tp,m,flag|0x1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(cm.imfilter)
		e1:SetReset(RESET_CHAIN)
		c:RegisterEffect(e1)
	elseif opval[op]==2 then
		Duel.SetFlagEffectLabel(tp,m,flag|0x2)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EFFECT_IMMUNE_EFFECT)
		e2:SetValue(cm.efilter)
		e2:SetReset(RESET_CHAIN)
		c:RegisterEffect(e2)
	elseif opval[op]==3 then
		Duel.SetFlagEffectLabel(tp,m,flag|0x4)
		if Duel.Destroy(c,REASON_EFFECT)~=0 then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetCode(EFFECT_IMMUNE_EFFECT)
			e3:SetTargetRange(LOCATION_MZONE,0)
			e3:SetReset(RESET_CHAIN)
			e3:SetValue(cm.efilter2)
			Duel.RegisterEffect(e3,tp)
		end
	end
end
function cm.imfilter(e,re,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return not g:IsContains(e:GetHandler())
end
function cm.efilter(e,te)
	local c=e:GetHandler()
	local ec=te:GetHandler()
	if ec:IsHasCardTarget(c) then return true end
	return te:IsHasType(EFFECT_TYPE_ACTIONS) and te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and c:IsRelateToEffect(te)
end
function cm.efilter2(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
