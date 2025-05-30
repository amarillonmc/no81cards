--神龙之子 琉迩
function c75000006.initial_effect(c)
	c:SetSPSummonOnce(75000006)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c75000006.matfilter,1,1)
	--direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetCondition(c75000006.incon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--destroy replace
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75000006,2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x3751))
	c:RegisterEffect(e1)
	--destroy
end

function c75000006.matfilter(c)
	return c:IsLinkSetCard(0x3751) and c:IsLinkAttribute(ATTRIBUTE_ALL&~ATTRIBUTE_WIND)
end