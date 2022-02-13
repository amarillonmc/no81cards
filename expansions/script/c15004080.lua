local m=15004080
local cm=_G["c"..m]
cm.name="荒仙天"
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),6,2)
	c:EnableReviveLimit()
	--3 times activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(15004080)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetTargetRange(LOCATION_SZONE,0)
	e2:SetTarget(cm.tfilter)
	c:RegisterEffect(e2)
end
function cm.tfilter(e,c)
	return c:IsSetCard(0x9f3e) and c:IsType(TYPE_TRAP+TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and e:GetHandler():GetColumnGroup():IsContains(c)
end