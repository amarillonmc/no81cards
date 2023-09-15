--スタティック・フュプノコーン
function c49811220.initial_effect(c)
    --synchro summon
    aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
    c:EnableReviveLimit()
    --atkdown
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(0,LOCATION_MZONE)
    e1:SetValue(c49811220.atkval)
    c:RegisterEffect(e1)
    --immune
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_IMMUNE_EFFECT)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetCondition(c49811220.condition)
    e2:SetRange(LOCATION_MZONE)
    e2:SetValue(c49811220.efilter)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_MATERIAL_CHECK)
    e3:SetValue(c49811220.valcheck)
    e3:SetLabelObject(e2)
    c:RegisterEffect(e3)
end
function c49811220.afilter(c)
    return c:IsFaceup() and c:IsType(TYPE_SPELL)
end
function c49811220.atkval(e,c)
    return Duel.GetMatchingGroupCount(c49811220.afilter,e:GetHandlerPlayer(),LOCATION_REMOVED,LOCATION_REMOVED,nil)*-200
end
function c49811220.valcheck(e,c)
    local g=c:GetMaterial()
    if g:FilterCount(Card.IsRace,nil,RACE_BEAST)==#g then
        e:GetLabelObject():SetLabel(1)
    else
        e:GetLabelObject():SetLabel(0)
    end
end
function c49811220.condition(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and e:GetLabel()==1
end
function c49811220.efilter(e,te)
    return te:IsActiveType(TYPE_SPELL) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end