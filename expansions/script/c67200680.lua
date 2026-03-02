--拟态武装 进化魔方
function c67200680.initial_effect(c)
	aux.AddLinkProcedure(c,c67200680.matfil,1,1)
	c:EnableReviveLimit()
	--hand link
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_SZONE,0)
	e3:SetTarget(c67200680.mattg)
	e3:SetValue(c67200680.matval)
	c:RegisterEffect(e3) 
end
function c67200680.matfil(c)
	return c:IsLinkSetCard(0x667b) and not c:IsLinkType(TYPE_LINK)
end
--
function c67200680.mfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x667b)
end
function c67200680.matval(e,lc,mg,c,tp)
	if not lc:IsType(TYPE_LINK) then return false,nil end
	return true,not mg or mg:IsExists(c67200680.mfilter,1,nil)
end
function c67200680.mattg(e,c)
	return c:IsSetCard(0x667b) and bit.band(c:GetOriginalType(),TYPE_MONSTER)==TYPE_MONSTER
end