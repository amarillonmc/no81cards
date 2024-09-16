--人理之诗 吾主在此
function c22020420.initial_effect(c)
	c:SetUniqueOnField(1,0,22020420)
	aux.AddCodeList(c,22020410)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--change effect type
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetCode(22020420)
	e0:SetRange(LOCATION_SZONE)
	e0:SetTargetRange(1,0)
	c:RegisterEffect(e0)
end
