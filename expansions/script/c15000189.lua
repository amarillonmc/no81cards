local m=15000189
local cm=_G["c"..m]
cm.name="做了场奇怪的梦"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Dream
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(15000189)
	e2:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e2)
	if not cm.DreamCheck then
		cm.DreamCheck=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVING)
		ge1:SetCondition(cm.chcon)
		ge1:SetOperation(cm.chop)
		Duel.RegisterEffect(ge1,0)
		_DreamIsRelateToEffect=Card.IsRelateToEffect
		function Card.IsRelateToEffect(c,e)
			local b1=Duel.IsExistingMatchingCard(cm.cfilter,0,LOCATION_SZONE,LOCATION_SZONE,1,nil)
			local b2=(e:GetHandler()==c and e:IsActivated())
			if b1 and b2 then return false end
			return _DreamIsRelateToEffect(c,e)
		end
	end
end
function cm.cfilter(c)
	return c:GetEffectCount(15000189)~=0 and c:IsFaceup() and c:IsStatus(STATUS_EFFECT_ENABLED) and not c:IsDisabled()
end
function cm.chcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return (rc:IsType(TYPE_CONTINUOUS) or rc:IsType(TYPE_FIELD) or rc:IsType(TYPE_PENDULUM) or rc:IsType(TYPE_EQUIP)) and re:GetOperation() and re:IsActivated()
end
function cm.chop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetOwner()
	local rc=re:GetHandler()
	local op=re:GetOperation()
	if not (rc:IsLocation(LOCATION_FZONE) or rc:IsLocation(LOCATION_SZONE) or rc:IsLocation(LOCATION_PZONE)) then return end
	if op then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(15000189)
		e1:SetTargetRange(1,0)
		e1:SetOperation(op)
		e1:SetLabelObject(re)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,0)
		re:SetOperation(cm.chaop)
	end
end
function cm.chaop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local se=Duel.IsPlayerAffectedByEffect(0,15000189)
	if not se then se=Duel.IsPlayerAffectedByEffect(1,15000189) end
	local op=nil
	if se then
		local x=1
		for _,i in ipairs{Duel.IsPlayerAffectedByEffect(0,15000189)} do
			if i:GetLabelObject()==e and x~=0 then
				op=i:GetOperation()
				i:Reset()
				x=0
			end
		end
	end
	local ag=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	if ag:GetCount()==0 then op(e,tp,eg,ep,ev,re,r,rp) return end
	if ag:GetCount()~=0 and c:IsRelateToEffect(e) then
		op(e,tp,eg,ep,ev,re,r,rp)
	end
end