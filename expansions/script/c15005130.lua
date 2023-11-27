local m=15005130
local cm=_G["c"..m]
cm.name="机神之心"
function cm.initial_effect(c)
	--redirect
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCondition(cm.recon)
	e0:SetValue(LOCATION_DECKBOT)
	c:RegisterEffect(e0)
end
function cm.recon(e)
	return e:GetHandler():IsFaceup()
end