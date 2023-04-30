local m=31400006
local cm=_G["c"..m]
cm.name=""
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetValue(m)
	c:RegisterEffect(e1)
end