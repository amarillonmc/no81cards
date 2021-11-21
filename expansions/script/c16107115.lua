--G-神智 紫云统夜后继机
local m=16107115
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c16199990") end,function() require("script/c16199990") end)
local nova=0x1cc
function cm.initial_effect(c)
	c:EnableCounterPermit(nova)
	--xyz summon
	aux.AddXyzProcedureLevelFree(c,cm.mfilter,nil,3,3)  
	c:EnableReviveLimit()
	--immune spell
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.effcon)
	e1:SetValue(cm.efilter)
	c:RegisterEffect(e1)
end
function cm.mfilter(c,xyzc)
	return c:IsType(TYPE_MONSTER) and rk.check(c,"GODONOVAARMS")
end
function cm.effcon(e)
	return e:GetHandler():GetOverlayCount()>0
end
function cm.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end