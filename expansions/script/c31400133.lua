local m=31400133
local cm=_G["c"..m]
cm.name="溟界之芜 底比斯"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,8,2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_XYZ_LEVEL)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(cm.lvtg)
	e1:SetValue(cm.lvval)
	c:RegisterEffect(e1)
end
function cm.lvtg(e,c)
	local rmve=c:IsHasEffect(EFFECT_LEAVE_FIELD_REDIRECT)
	if not rmve then return false end
	return c:IsLevelAbove(1) and c:IsRace(RACE_REPTILE) and rmve:GetValue()==LOCATION_REMOVED 
end
function cm.lvval(e,c,rc)
	local lv=c:GetLevel()
	if rc==e:GetHandler() then return 8
	else return lv end
end