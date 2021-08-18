local m=15000300
local cm=_G["c"..m]
cm.name="世界墟-『 』"
function cm.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,15000110,15000177,true,true)
	--Recording Zone
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_MOVE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCondition(cm.rzcon)
	e0:SetOperation(cm.rzop)
	c:RegisterEffect(e0)
	--Move
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetOperation(cm.moop)
	c:RegisterEffect(e1)
	--summon success
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(cm.regcon)
	e2:SetOperation(cm.reg1op)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(cm.valcheck)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--summon success
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(cm.regcon)
	e4:SetOperation(cm.reg2op)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_MATERIAL_CHECK)
	e5:SetValue(cm.valcheck)
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)
end
function cm.rzcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	return c:IsLocation(LOCATION_MZONE) and (c:GetPreviousSequence()~=c:GetSequence() or tp~=c:GetPreviousControler())
end
function cm.rzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	if tp~=c:GetPreviousControler() then
		if c:GetFlagEffect(0)~=0 then c:ResetFlagEffect(0) end
		if c:GetFlagEffect(1)~=0 then c:ResetFlagEffect(1) end
		if c:GetFlagEffect(2)~=0 then c:ResetFlagEffect(2) end
		if c:GetFlagEffect(3)~=0 then c:ResetFlagEffect(3) end
		if c:GetFlagEffect(4)~=0 then c:ResetFlagEffect(4) end
	end
	local seq=c:GetSequence()
	if seq==0 then
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,5))
	end
	if seq==1 then
		c:RegisterFlagEffect(1,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,6))
	end
	if seq==2 then
		c:RegisterFlagEffect(2,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,7))
	end
	if seq==3 then
		c:RegisterFlagEffect(3,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,8))
	end
	if seq==4 then
		c:RegisterFlagEffect(4,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,9))
	end
end
function cm.moop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local zone=0
	if c:GetFlagEffect(0)~=0 then zone=zone+0x1 end
	if c:GetFlagEffect(1)~=0 then zone=zone+0x2 end
	if c:GetFlagEffect(2)~=0 then zone=zone+0x4 end
	if c:GetFlagEffect(3)~=0 then zone=zone+0x8 end
	if c:GetFlagEffect(4)~=0 then zone=zone+0x10 end
	local zone2=0x1f~zone
	local x=1
	if Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,LOCATION_REASON_TOFIELD,zone2)<=0 then x=2 end
	if Duel.GetFlagEffect(tp,15000306)~=0 and Duel.SelectYesNo(tp,aux.Stringid(15000306,5)) then Duel.ResetFlagEffect(tp,15000306) return end
	if x==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,zone)
		local nseq=math.log(s,2)
		Duel.MoveSequence(c,nseq)
	end
	if x==2 then
		Duel.SendtoGrave(c,REASON_RULE)
	end
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) and e:GetLabel()==1
end
function cm.reg1op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(cm.efilter)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	c:RegisterFlagEffect(15000300,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0))
end
function cm.reg2op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--set instead of send to grave
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.setcon)
	e2:SetOperation(cm.setop)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)
end
function cm.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsFusionCode,1,nil,15000110) and g:IsExists(Card.IsFusionCode,1,nil,15000177) and g:GetCount()==2 then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function cm.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function cm.setcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if eg and eg:IsContains(c) then return end
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and ((re:IsActiveType(TYPE_TRAP)
		and rc:GetType()==TYPE_TRAP) or (re:IsActiveType(TYPE_SPELL)
		and rc:GetType()==TYPE_SPELL)) and rc:IsRelateToEffect(re) and rc:IsCanTurnSet() and rc:IsStatus(STATUS_LEAVE_CONFIRMED)
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	Duel.Hint(HINT_CARD,1-tp,15000300)
	rc:CancelToGrave()
	Duel.ChangePosition(rc,POS_FACEDOWN)
	Duel.RaiseEvent(rc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
end