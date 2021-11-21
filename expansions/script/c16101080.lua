--曾被称为狐的龟
local m=16101080
local cm=_G["c"..m]
function cm.initial_effect(c)
	--disable spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetTarget(cm.sumlimit)
	c:RegisterEffect(e1)
end
function cm.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsAttackAbove(1800) and c:IsRace(RACE_BEAST)
end