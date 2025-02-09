--甲虫武士
function c65899935.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c65899935.matfilter,1,1)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_INSECT))
	e3:SetValue(500)
	c:RegisterEffect(e3)
end
function c65899935.matfilter(c)
	return c:IsLinkRace(RACE_INSECT) and not c:IsLinkType(TYPE_LINK)
end