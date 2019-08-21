--李奥瑞克 骷髅王
if not pcall(function() require("expansions/script/c10121001") end) then require("script/c10121001") end
function c10121009.initial_effect(c)
	rsdio.DMSpecialSummonEffect(c,10121009,true)
	--xyz
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(10121003)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD)
	c:RegisterEffect(e1)
end
