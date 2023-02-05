--机壳守护神 原核
local m=89387023
local cm=_G["c"..m]
function cm.initial_effect(c)
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0xaa),1,1)
    c:EnableReviveLimit()
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,m)
    e1:SetCondition(cm.hspcon)
    e1:SetTarget(cm.hsptg)
    e1:SetOperation(cm.hspop)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetOperation(cm.regop)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_BE_MATERIAL)
    e3:SetCondition(cm.effcon)
    e3:SetOperation(cm.effop)
    c:RegisterEffect(e3)
end
function cm.hspcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.hspfilter(c,e,tp)
    return c:IsSetCard(0xaa) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function cm.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.hspfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function cm.hspop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,cm.hspfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE) then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CANNOT_TRIGGER)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
    end
    Duel.SpecialSummonComplete()
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetFlagEffect(tp,m)~=0 then return end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetDescription(aux.Stringid(m,0))
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
    e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
    e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xaa))
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
    Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
end
function cm.effcon(e,tp,eg,ep,ev,re,r,rp)
    return r==REASON_LINK
end
function cm.effop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local rc=c:GetReasonCard()
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,1))
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
    e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e1:SetValue(cm.indval)
    e1:SetOwnerPlayer(ep)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
    rc:RegisterEffect(e1,true)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetValue(1000)
    e2:SetReset(RESET_EVENT+RESETS_STANDARD)
    rc:RegisterEffect(e2,true)
end
function cm.indval(e,re,rp)
    return rp==1-e:GetOwnerPlayer()
end
