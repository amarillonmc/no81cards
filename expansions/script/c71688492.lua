--五魔龙
local s,id=GetID()
function s.initial_effect(c)
    c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),5,true)
	aux.AddContactFusionProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),LOCATION_GRAVE+LOCATION_REMOVED,0,aux.tdcfop(c)):SetValue(SUMMON_VALUE_SELF)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(s.splimit)
	c:RegisterEffect(e1)
end
function s.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end