--食大食蚁兽蚁洞
local m=11451475
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x11e0)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(cm.condition)
	e2:SetCost(cm.cost)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_ACTIVATE_COST)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,0)
	e4:SetTarget(cm.actarget)
	e4:SetOperation(cm.costop)
	c:RegisterEffect(e4)
	--hint
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetOperation(cm.chkop)
	c:RegisterEffect(e5)
end
function cm.actarget(e,te,tp)
	e:SetLabelObject(te)
	return te:GetHandler()==e:GetHandler()
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,false)
	e:GetHandler():CreateEffectRelation(te)
end
function cm.chkop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ref=c:GetReasonEffect()
	if c:IsReason(REASON_COST) and ref and ref:GetCode()==EFFECT_SPSUMMON_PROC and ref:GetHandler():IsRace(RACE_INSECT) then
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,7))
	end
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ref=c:GetReasonEffect()
	return c:IsReason(REASON_COST) and ref and ref:GetCode()==EFFECT_SPSUMMON_PROC and ref:GetHandler():IsRace(RACE_INSECT) and not c:IsPreviousLocation(LOCATION_REMOVED)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if chk==0 then return ft>1 end
end
function cm.filter(c)
	return c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) and ft>0 and (ft>1 or not e:GetHandler():IsLocation(LOCATION_HAND)) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():SetStatus(STATUS_EFFECT_ENABLED,true)
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local max=g:GetClassCount(Card.GetAttribute)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	aux.GCheckAdditional=aux.dabcheck
	local sg=g:SelectSubGroup(tp,aux.TRUE,false,1,math.min(max,ft))
	aux.GCheckAdditional=nil
	if not sg or #sg==0 then return end
	for tc in aux.Next(sg) do
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_EVENT_PLAYER)
		e2:SetCode(EVENT_LEAVE_FIELD_P)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetOperation(cm.efop1)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_EVENT_PLAYER)
		e3:SetCode(EVENT_BE_MATERIAL)
		e3:SetOperation(cm.efop2)
		e2:SetLabelObject(e3)
		e3:SetLabelObject(e2)
		tc:RegisterEffect(e2,true)
		tc:RegisterEffect(e3,true)
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_DELAY)
		e4:SetCode(EVENT_MOVE)
		e4:SetLabelObject(e3)
		e4:SetOperation(cm.resop)
		tc:RegisterEffect(e4,true)
		tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0))
	end
end
function cm.efop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ref=c:GetReasonEffect()
	if not ((c:IsReason(REASON_COST) or c:IsReason(REASON_MATERIAL)) and ref and ref:GetCode()==EFFECT_SPSUMMON_PROC) then return end
	local rc=ref:GetHandler()
	if not rc then return end
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_ADD_TYPE)
	e0:SetValue(TYPE_EFFECT)
	e0:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
	local ab=c:GetOriginalAttribute()
	if bit.band(ab,ATTRIBUTE_EARTH+ATTRIBUTE_WIND)~=0 and rc:GetFlagEffect(m)==0 then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(m,1))
		e1:SetCategory(CATEGORY_DESTROY)
		e1:SetType(EFFECT_TYPE_QUICK_O)
		e1:SetCode(EVENT_CHAINING)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCountLimit(1)
		e1:SetCondition(cm.descon)
		e1:SetTarget(cm.destg)
		e1:SetOperation(cm.desop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		rc:RegisterEffect(e1,true)
		if not rc:IsType(TYPE_EFFECT) then rc:RegisterEffect(e0,true) end
		rc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1))
	end
	if bit.band(ab,ATTRIBUTE_WATER+ATTRIBUTE_FIRE)~=0 and rc:GetFlagEffect(m+1)==0 then
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(m,2))
		e2:SetCategory(CATEGORY_DRAW)
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e2:SetProperty(EFFECT_FLAG_DELAY)
		e2:SetCode(EVENT_BATTLE_DESTROYING)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		--e2:SetCountLimit(1)
		e2:SetCondition(cm.drcon1)
		e2:SetTarget(cm.drtg)
		e2:SetOperation(cm.drop)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		rc:RegisterEffect(e2,true)
		local e3=e2:Clone()
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e3:SetCode(EVENT_DESTROYED)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCondition(cm.drcon2)
		rc:RegisterEffect(e3,true)
		if not rc:IsType(TYPE_EFFECT) then rc:RegisterEffect(e0,true) end
		rc:RegisterFlagEffect(m+1,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,2))
	end
	if bit.band(ab,ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)~=0 and rc:GetFlagEffect(m+2)==0 then
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e5:SetRange(LOCATION_MZONE)
		e5:SetCode(EVENT_CHAINING)
		e5:SetCondition(cm.discon)
		e5:SetOperation(cm.disop)
		e5:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		rc:RegisterEffect(e5,true)
		if not rc:IsType(TYPE_EFFECT) then rc:RegisterEffect(e0,true) end
		rc:RegisterFlagEffect(m+2,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,3))
	end
	c:ResetFlagEffect(0)
	local te=e:GetLabelObject()
	if te~=nil and aux.GetValueType(te)=="Effect" then te:Reset() end
	e:Reset()
end
function cm.efop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	if eg~=nil then
		rc=eg:GetFirst()
		local ref=rc:GetReasonEffect()
		if not (ref and ref==c:GetReasonEffect()) then return end
	end
	if not rc then return end
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_ADD_TYPE)
	e0:SetValue(TYPE_EFFECT)
	e0:SetReset(RESET_EVENT+RESETS_STANDARD)
	local ab=c:GetOriginalAttribute()
	if bit.band(ab,ATTRIBUTE_EARTH+ATTRIBUTE_WIND)~=0 and rc:GetFlagEffect(m)==0 then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(m,1))
		e1:SetCategory(CATEGORY_DESTROY)
		e1:SetType(EFFECT_TYPE_QUICK_O)
		e1:SetCode(EVENT_CHAINING)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCountLimit(1)
		e1:SetCondition(cm.descon)
		e1:SetTarget(cm.destg)
		e1:SetOperation(cm.desop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e1,true)
		if not rc:IsType(TYPE_EFFECT) then rc:RegisterEffect(e0,true) end
		rc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1))
	end
	if bit.band(ab,ATTRIBUTE_WATER+ATTRIBUTE_FIRE)~=0 and rc:GetFlagEffect(m+1)==0 then
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(m,2))
		e2:SetCategory(CATEGORY_DRAW)
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e2:SetProperty(EFFECT_FLAG_DELAY)
		e2:SetCode(EVENT_BATTLE_DESTROYING)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetCountLimit(1)
		e2:SetCondition(cm.drcon1)
		e2:SetTarget(cm.drtg)
		e2:SetOperation(cm.drop)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e2,true)
		local e3=e2:Clone()
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e3:SetCode(EVENT_DESTROYED)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCondition(cm.drcon2)
		rc:RegisterEffect(e3,true)
		if not rc:IsType(TYPE_EFFECT) then rc:RegisterEffect(e0,true) end
		rc:RegisterFlagEffect(m+1,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,2))
	end
	if bit.band(ab,ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)~=0 and rc:GetFlagEffect(m+2)==0 then
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e5:SetRange(LOCATION_MZONE)
		e5:SetCode(EVENT_CHAINING)
		e5:SetCondition(cm.discon)
		e5:SetOperation(cm.disop)
		e5:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e5,true)
		if not rc:IsType(TYPE_EFFECT) then rc:RegisterEffect(e0,true) end
		rc:RegisterFlagEffect(m+2,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,3))
	end
	c:ResetFlagEffect(0)
	local te=e:GetLabelObject()
	if te~=nil and aux.GetValueType(te)=="Effect" then te:Reset() end
	e:Reset()
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=re:GetHandler()
	if chk==0 then return true end
	if rc:IsDestructable() and rc:IsRelateToEffect(re) then Duel.SetOperationInfo(0,CATEGORY_DESTROY,rc,1,0,0) end
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetLabelObject(re)
		e1:SetValue(cm.efilter)
		e1:SetReset(RESET_CHAIN)
		c:RegisterEffect(e1)
		if rc:IsRelateToEffect(re) then Duel.Destroy(rc,REASON_EFFECT) end
	end
end
function cm.efilter(e,re)
	return re==e:GetLabelObject()
end
function cm.drcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsRelateToBattle()
end
function cm.drcon2(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0 and re:GetHandler()==e:GetHandler()
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(m+1)<2 end
	c:RegisterFlagEffect(m+1,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler()==e:GetHandler()
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetTargetRange(0,LOCATION_ONFIELD)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
	e:GetHandler():RegisterEffect(e1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetLabel(ev)
	e2:SetLabelObject(e1)
	e2:SetCondition(cm.rescon)
	e2:SetOperation(cm.resop)
	e2:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e2,tp)
	local e3=e2:Clone()
	e3:SetCode(EVENT_CHAIN_NEGATED)
	Duel.RegisterEffect(e3,tp)
end
function cm.rescon(e,tp,eg,ep,ev,re,r,rp)
	return ev==e:GetLabel()
end
function cm.resop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsLocation(LOCATION_SZONE) then return end
	local te=e:GetLabelObject()
	if te~=nil and aux.GetValueType(te)=="Effect" then
		local te2=te:GetLabelObject()
		if te2~=nil and aux.GetValueType(te2)=="Effect" then te2:Reset() end
		te:Reset()
	end
	e:Reset()
end