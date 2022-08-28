local m=90700015
local cm=_G["c"..m]
cm.name="钟楼使徒 伊东"
if not pcall(function() require("expansions/script/c90700019") end) then require("expansions/script/c90700019") end
function cm.initial_effect(c)
	Seine_clock_tower.enable(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(1,0)
	e1:SetCondition(cm.actcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=Effect.Clone(e1)
	e2:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	c:RegisterEffect(e2)
	local e3=Effect.Clone(e1)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	c:RegisterEffect(e3)
end
function cm.actcon(e)
	return e:GetHandler():IsPublic()
end