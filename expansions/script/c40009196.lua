--时机变换
local m=40009196
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,40009190)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--change effect type
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(m)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(1,0)
	c:RegisterEffect(e2)
	--splimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetTarget(cm.splimit)
	c:RegisterEffect(e3)

	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_ADD_CODE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(cm.tg)
	e4:SetValue(40009190)
	e4:SetRange(LOCATION_FZONE)
	c:RegisterEffect(e4)
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not (c:IsCode(40009190) or aux.IsCodeListed(c,40009190)) and not c:IsLocation(LOCATION_EXTRA)
end
function cm.tg(e,c)
	return aux.IsCodeListed(c,40009190) and c:IsType(TYPE_XYZ) 
end