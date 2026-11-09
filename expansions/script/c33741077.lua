--Replace Effect Innocent Shower
function c33741077.initial_effect(c)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c33741077.efilter)
	c:RegisterEffect(e1)
end
function c33741077.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
