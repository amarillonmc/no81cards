--仪式之门
local m=14010190
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--ritual
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTarget(aux.RitualUltimateTarget(nil,Card.GetLevel,"Greater",LOCATION_HAND,cm.mfilter,nil))
	e2:SetOperation(aux.RitualUltimateOperation(nil,Card.GetLevel,"Greater",LOCATION_HAND,cm.mfilter,nil))
	c:RegisterEffect(e2)
end
function cm.mfilter(c)
	return c:IsType(TYPE_RITUAL)
end