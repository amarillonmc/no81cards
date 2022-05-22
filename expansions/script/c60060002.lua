--逆魔刃 贰叁琉
local m=60060002
local cm=_G["c"..m]
function cm.initial_effect(c)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(cm.efilter)
	c:RegisterEffect(e1)
end
function cm.efilter(e,te)
	local c=te:GetHandler()
	return c:GetType()==TYPE_SPELL
end