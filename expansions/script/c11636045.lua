--渊洋海兽 黄金锤头鲨
local m = 11636045
local cm = _G["c"..m]
function cm.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--to hand or summon 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_NONTUNER)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetValue(cm.tnval)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_SYNCHRO_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_HAND)
	e2:SetValue(cm.matval)
	c:RegisterEffect(e2)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_BE_PRE_MATERIAL)
	e0:SetProperty(EFFECT_FLAG_EVENT_PLAYER+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetLabelObject(e1)
	e0:SetCondition(cm.hsyncon)
	e0:SetOperation(cm.hsynreg)
	c:RegisterEffect(e0)
	--synchro material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_SEND_REPLACE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetTarget(cm.reptg)
	c:RegisterEffect(e3)
	--debuff
	if not cm.globalcheck then
		cm.globalcheck=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CUSTOM+m)
	e4:SetRange(LOCATION_EXTRA)
	e4:SetCondition(cm.decon)
	e4:SetOperation(cm.deop)
	c:RegisterEffect(e4)
	--to grave
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_EXTRA)
	e5:SetCountLimit(1)
	e5:SetCondition(cm.tgcon)
	e5:SetOperation(cm.tgop)
	c:RegisterEffect(e5)
	--
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(rp,m)~=0 then
		local n=Duel.GetFlagEffectLabel(rp,m)+1
		Duel.SetFlagEffectLabel(rp,m,n)
		if n%3==0 then
			Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+m,e,0,rp,0,0)
		end
	else
		Duel.RegisterFlagEffect(rp,m,RESET_PHASE+PHASE_END,0,1,1)
	end
end
--
function cm.tnval(e,c)
	return e:GetHandler():IsControler(c:GetControler()) and c:IsSetCard(0x223)
end
function cm.matval(e,c)
	return c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x223)
end
function cm.hsyncon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return r==REASON_SYNCHRO and cm.matval(nil,c:GetReasonCard()) and c:IsPreviousLocation(LOCATION_HAND)
end
function cm.hsynreg(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():UseCountLimit(tp)
end
--
function cm.repfilter(c)
	return  c:GetLeaveFieldDest()==0 and bit.band(c:GetReason(),REASON_MATERIAL+REASON_SYNCHRO)==REASON_MATERIAL+REASON_SYNCHRO  and  c:GetReasonCard():IsSetCard(0x223)
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return cm.repfilter(c)
	end
	if cm.repfilter(c) then
		Duel.SendtoExtraP(c,1-c:GetControler(),REASON_EFFECT+REASON_REDIRECT)
		return true
	end
	return false
end
--
function cm.decon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOwner()~=tp and rp==tp
end

function cm.oprep(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	if Duel.DiscardDeck(tp,1,REASON_EFFECT) then
		local tc=Duel.GetOperatedGroup():GetFirst()
		if tc:IsLocation(0x10) then
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_CANNOT_TRIGGER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3)
		end
		Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+11636070,e,0,0,0,0)
	end
end

function cm.deop(e,tp,eg,ep,ev,re,r,rp)
	cm.oprep(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,11636065) then
		cm.oprep(e,tp,eg,ep,ev,re,r,rp)
	end
end
--
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetHandler():GetOwner()
	local tp=e:GetHandlerPlayer()
	return Duel.GetTurnPlayer()==tp and p~=e:GetHandler():GetControler()
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end