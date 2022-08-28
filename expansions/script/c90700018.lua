local m=90700018
local cm=_G["c"..m]
cm.name="钟楼使徒 玛夏"
if not pcall(function() require("expansions/script/c90700019") end) then require("expansions/script/c90700019") end
function cm.initial_effect(c)
	Seine_clock_tower.enable(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e1:SetTargetRange(0xff,0xfe)
	e1:SetValue(LOCATION_REMOVED)
	e1:SetCondition(cm.actcon)
	e1:SetTarget(cm.rmtg)
	c:RegisterEffect(e1)
end
function cm.actcon(e)
	return e:GetHandler():IsPublic()
end
function cm.rmtg(e,c)
	return c:GetOwner()==e:GetHandlerPlayer()
end