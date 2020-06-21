--深海衍生物
function c79029101.initial_effect(c)
	--double tribute
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_DOUBLE_TRIBUTE)
	e5:SetValue(c79029101.effcon)
	c:RegisterEffect(e5)   
end
function c79029101.effcon(e,c)
	return c:IsSetCard(0xf02) or c:IsAttribute(ATTRIBUTE_WATER)
end