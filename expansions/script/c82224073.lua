local m=82224073
local cm=_G["c"..m]
cm.name="煞白天使 时之支配者"
function cm.initial_effect(c)
	--fusion material  
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsRace,RACE_FAIRY),2,true)  
	c:EnableReviveLimit()  
	--disable  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_DISABLE)  
	e1:SetRange(LOCATION_MZONE)  
	e1:SetTargetRange(0,LOCATION_MZONE)  
	e1:SetTarget(cm.distg)  
	c:RegisterEffect(e1)  
end
function cm.distg(e,c)  
	return c:IsStatus(STATUS_SPSUMMON_TURN) and c:IsSummonType(SUMMON_TYPE_SPECIAL)  
end  