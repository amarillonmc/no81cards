--冗长城池君主 王将之座君临晶
local m=14000401
local cm=_G["c"..m]
function cm.initial_effect(c)
	--cannot be activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,1)
	e1:SetTarget(cm.actlimit)
	Duel.RegisterEffect(e1,tp)
	--cannot remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_CANNOT_REMOVE)
	e2:SetRange(LOCATION_FZONE)
	c:RegisterEffect(e2)
	--immune
	local e3=e2:Clone()
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetValue(cm.efilter)
	c:RegisterEffect(e3)
	--cannot to deck
	local e4=e2:Clone()
	e4:SetCode(EFFECT_CANNOT_TO_DECK)
	c:RegisterEffect(e4)
	--cannot release
	local e5=e2:Clone()
	e5:SetCode(EFFECT_UNRELEASABLE_SUM)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e6)
	--self destroy
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(m,0))
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_PHASE+PHASE_END)
	e7:SetRange(LOCATION_FZONE)
	e7:SetOperation(cm.sdop)
	c:RegisterEffect(e7)
	--redirect
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e8:SetCondition(cm.recon)
	e8:SetValue(LOCATION_HAND)
	c:RegisterEffect(e8)
end
function cm.actlimit(e,te,tp)
	return te:IsHasType(EFFECT_TYPE_ACTIVATE) and te:GetHandler():GetOriginalCode()==m
end
function cm.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function cm.sdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Destroy(c,REASON_EFFECT)
end
function cm.recon(e)
	return e:GetHandler():IsFaceup()
end