--里械仪者·到来
local m = 114503
local cm = _G["c"..m]
function cm.initial_effect(c)
	local e1=aux.AddRitualProcGreater2(c,aux.FilterBoolFunction(Card.IsSetCard,0xca1),LOCATION_HAND+LOCATION_DECK,nil,aux.FilterBoolFunction(Card.IsType,TYPE_FLIP))
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
end
