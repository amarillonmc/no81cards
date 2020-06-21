--机怪巨兵 「AURAM」
local m=89388017
local cm=_G["c"..m]
function cm.initial_effect(c)
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0xcc21),2,2)
    c:EnableReviveLimit()
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTargetRange(LOCATION_ONFIELD,0)
    e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xcc21))
    e4:SetValue(cm.indvalue)
    c:RegisterEffect(e4)
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,m)
    e2:SetCondition(cm.spcon1)
    e2:SetTarget(cm.sptg1)
    e2:SetOperation(cm.spop1)
    c:RegisterEffect(e2)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_DESTROY_REPLACE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTarget(cm.destg)
    e1:SetValue(cm.value)
    e1:SetOperation(cm.desop)
    c:RegisterEffect(e1)
end
function cm.indvalue(e,re)
    return re:GetHandlerPlayer()~=e:GetHandlerPlayer()
end
function cm.spcon1(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetLinkedGroupCount()==0
end
function cm.spfilter1(c,e,tp)
    return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return e:GetHandler():GetLinkedZone(tp)&0x1f>0 and Duel.IsExistingMatchingCard(cm.spfilter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function cm.spop1(e,tp,eg,ep,ev,re,r,rp)
    local zone=e:GetHandler():GetLinkedZone(tp)
    if zone&0x1f==0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,cm.spfilter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    if not g or g:GetCount()==0 then return end
    Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)
end
function cm.dfilter(c,tp)
    return c:IsFaceup() and c:IsSetCard(0xcc21) and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsReason(REASON_BATTLE)
end
function cm.repfilter(c)
    return c:IsSetCard(0xcc21) and c:IsAbleToRemove()
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return eg:IsExists(cm.dfilter,1,nil,tp) and Duel.IsExistingMatchingCard(cm.repfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
    return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function cm.value(e,c)
    return cm.dfilter(c,e:GetHandlerPlayer())
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,cm.repfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
    Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
