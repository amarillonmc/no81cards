local m=31417010
local cm=_G["c"..m]
cm.name="歌声之圣域"
if not pcall(function() require("expansions/script/c31417000") end) then require("expansions/script/c31417000") end
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(1,0)
	e1:SetValue(cm.actlimit)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SSET)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(cm.setlimit)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetValue(cm.efilter)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_ADJUST)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetOperation(cm.fieldop)
	c:RegisterEffect(e4)
end
function cm.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cm.setlimit(e,c,tp)
	return c:IsType(TYPE_FIELD)
end
function cm.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function cm.fieldop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,Seine_Vocaloid.field) then return end
	Duel.Remove(e:GetHandler(),POS_FACEDOWN,REASON_RULE)
end