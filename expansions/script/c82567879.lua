--方舟连接者 Castle-3
function c82567879.initial_effect(c)
	--hand link
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,82567879)
	e1:SetValue(c82567879.matval)
	c:RegisterEffect(e1)
end
function c82567879.mfilter(c)
	return c:IsLocation(LOCATION_MZONE) 
end
function c82567879.exmfilter(c)
	return c:IsLocation(LOCATION_HAND) and c:IsCode(82567879)
end
function c82567879.matval(e,lc,mg,c,tp)
	if not lc:IsSetCard(0x825) then return false,nil end
	return true,not mg or mg:IsExists(c82567879.mfilter,1,nil) and not mg:IsExists(c82567879.exmfilter,1,nil)
end