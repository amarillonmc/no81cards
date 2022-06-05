--污秽的大地
local m=60060033
local cm=_G["c"..m]
cm.name="污秽的大地"
cm.isArkFog=true
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(cm.efilter)
	c:RegisterEffect(e1)
end
function cm.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end