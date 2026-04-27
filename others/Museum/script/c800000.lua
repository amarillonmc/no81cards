--兔子衍生物
local m=800000
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Normal monster
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_TYPE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(TYPE_TUNER)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NONTUNER)
	e2:SetValue(cm.tnval)
	c:RegisterEffect(e2)
end
function cm.tnval(e,c)
	return e:GetHandler():IsControler(c:GetControler())
end
