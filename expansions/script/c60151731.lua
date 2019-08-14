--天空的水晶部队 符文操控师
function c60151731.initial_effect(c)
    --synchro summon
    aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x3b26),aux.NonTuner(nil),1)
    c:EnableReviveLimit()
    --dis
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(60151731,0))
    e1:SetCategory(CATEGORY_DISABLE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e1:SetTarget(c60151731.distg)
    e1:SetOperation(c60151731.disop)
    c:RegisterEffect(e1)
    --des
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(60151731,1))
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,60151731)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetHintTiming(0,0x1e0)
    e2:SetTarget(c60151731.destg)
    e2:SetOperation(c60151731.desop)
    c:RegisterEffect(e2)
    --special summon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(60151731,2))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetCountLimit(1,6011731)
    e3:SetTarget(c60151731.target2)
    e3:SetOperation(c60151731.operation2)
    c:RegisterEffect(e3)
end
function c60151731.disfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_EFFECT) and not c:IsDisabled() 
        and bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end
function c60151731.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60151731.disfilter,tp,0,LOCATION_MZONE,1,nil) end
    local g=Duel.GetMatchingGroup(c60151731.disfilter,tp,0,LOCATION_MZONE,nil)
    Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c60151731.disop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(c60151731.disfilter,tp,0,LOCATION_MZONE,nil)
    local tc=g:GetFirst()
    while tc do
        Duel.NegateRelatedChain(tc,RESET_TURN_SET)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetValue(RESET_TURN_SET)
        e2:SetReset(RESET_EVENT+0x1fe0000)
        tc:RegisterEffect(e2)
        tc=g:GetNext()
    end
end
function c60151731.desfilter(c)
    return c:IsFaceup() and c:IsDisabled()
end
function c60151731.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingTarget(c60151731.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,c60151731.desfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c60151731.desop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.Destroy(tc,REASON_EFFECT)
    end
end
function c60151731.filter(c,e,tp)
    return c:IsSetCard(0x3b26) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60151731.filter2(c,ft)
    if ft==0 then
        return c:IsType(TYPE_MONSTER) and c:IsDestructable()
            and c:IsLocation(LOCATION_MZONE) and c:IsFaceup()
    else
        return c:IsType(TYPE_MONSTER) and c:IsDestructable()
            and ((c:IsLocation(LOCATION_MZONE) and c:IsFaceup()) or c:IsLocation(LOCATION_HAND))
    end
end
function c60151731.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if chk==0 then return Duel.IsExistingMatchingCard(c60151731.filter2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,ft)
        and Duel.IsExistingTarget(c60151731.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c60151731.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
    local g2=Duel.GetMatchingGroup(c60151731.filter2,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,ft)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g2,1,0,0)
end
function c60151731.operation2(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
        local g=Duel.SelectMatchingCard(tp,c60151731.filter2,tp,LOCATION_MZONE,0,1,1,nil,ft)
        if g:GetCount()>0 then
            Duel.HintSelection(g)
            if Duel.Destroy(g,REASON_EFFECT)~=0 then
                if tc:IsRelateToEffect(e) then
                    Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
                end
            end
        end
    else
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
        local g=Duel.SelectMatchingCard(tp,c60151731.filter2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,ft)
        if g:GetCount()>0 then
            Duel.HintSelection(g)
            if Duel.Destroy(g,REASON_EFFECT)~=0 then
                if tc:IsRelateToEffect(e) then
                    Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
                end
            end
        end
    end
end
