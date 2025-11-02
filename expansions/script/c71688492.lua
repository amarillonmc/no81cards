--五魔龙
local s,id=GetID()
function s.initial_effect(c)
    c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),5,true)
	aux.AddContactFusionProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),LOCATION_GRAVE+LOCATION_REMOVED,0,aux.tdcfop(c)):SetValue(SUMMON_VALUE_SELF)
	local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e0:SetCode(EVENT_SPSUMMON_SUCCESS)
    e0:SetCondition(s.condition)
    e0:SetOperation(s.regop)
    c:RegisterEffect(e0)
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
function s.condition(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetTargetRange(1,0)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetTarget(s.splimit1)
    Duel.RegisterEffect(e1,tp)
end
function s.splimit1(e,c,sump,sumtype,sumpos,targetp,se)
    return c:IsCode(id) and bit.band(sumtype,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end