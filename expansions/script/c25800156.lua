--誓约之戒
local m=25800156
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_BE_MATERIAL)
	e0:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e0:SetCondition(cm.atkcon)
	e0:SetOperation(cm.atkop)
	c:RegisterEffect(e0)
end
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO or r==REASON_FUSION or r==REASON_XYZ 
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetValue(cm.tgval)
	e2:SetOwnerPlayer(ep)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e2,true)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(cm.efilter)
	rc:RegisterEffect(e3,true)
end
function cm.efilter(e,te)
	local c=e:GetHandler()
	local ec=te:GetHandler()
	if ec:IsHasCardTarget(c) or (te:IsHasType(EFFECT_TYPE_ACTIONS) and te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and c:IsRelateToEffect(te)) then return false
	end
	return e:GetHandlerPlayer()==te:GetOwnerPlayer()
end
function cm.tgval(e,re,rp)
	return rp==1-e:GetOwnerPlayer() 
end
