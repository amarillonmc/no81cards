local m=53799183
local cm=_G["c"..m]
cm.name="自奏圣乐·挥剑"
function cm.initial_effect(c)
	aux.AddLinkProcedure(c,cm.matfilter,1,1)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetTarget(cm.mattg)
	e0:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e0:SetTargetRange(LOCATION_HAND,0)
	e0:SetValue(cm.matval)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetCondition(cm.con)
	e1:SetTarget(cm.splimit)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCondition(cm.recon)
	e2:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	--e3:SetCondition(cm.xyzcon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function cm.matfilter(c)
	return c:IsLinkAttribute(ATTRIBUTE_DARK) and c:IsLinkRace(RACE_MACHINE) and c:IsLevelAbove(1)
end
function cm.matval(e,lc,mg,c,tp)
	if e:GetHandler()~=lc then return false,nil end
	return true,true
end
function cm.mattg(e,c)
	return c:IsSetCard(0xfe) and c:IsType(TYPE_MONSTER)
end
function cm.splimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_DARK)
end
function cm.con(e)
	return not e:GetHandler():IsLinkState()
end
function cm.recon(e)
	return e:GetHandler():IsLocation(LOCATION_ONFIELD)
end
function cm.xyzcon(e)
	local c=e:GetHandler()
	return c:IsStatus(STATUS_SPSUMMON_TURN) and c:IsSummonType(SUMMON_TYPE_LINK)
end
