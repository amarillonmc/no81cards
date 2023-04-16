local m=82224073
local cm=_G["c"..m]
cm.name="煞白天使 时之支配者"
function cm.initial_effect(c)
	--fusion material  
	aux.AddFusionProcFunRep(c,cm.ffilter,3,true)  
	c:EnableReviveLimit()  
	--spsummon condition  
	local e0=Effect.CreateEffect(c)  
	e0:SetType(EFFECT_TYPE_SINGLE)  
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)  
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)  
	e0:SetValue(aux.fuslimit)  
	c:RegisterEffect(e0)  
	--disable  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_DISABLE)  
	e1:SetRange(LOCATION_MZONE)  
	e1:SetTargetRange(0,LOCATION_MZONE)  
	e1:SetTarget(cm.distg)  
	c:RegisterEffect(e1)  
end
function cm.ffilter(c)  
	return c:IsRace(RACE_FAIRY) and (c:IsOnField() or c:IsLocation(LOCATION_HAND))
end  
function cm.distg(e,c)  
	return c:IsStatus(STATUS_SPSUMMON_TURN) and c:IsSummonType(SUMMON_TYPE_SPECIAL)  
end  