--Re:SURGUM 天光之魔女
local m=60002039
local cm=_G["c"..m]
cm.name="Re:SURGUM 天光之魔女"
function cm.initial_effect(c)
	--cannot release
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetCode(EFFECT_CANNOT_RELEASE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	c:RegisterEffect(e2)
end
