--分離するブラッド・ソウル
function c49811402.initial_effect(c)
    --to hand
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(49811402,0))
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
    e1:SetCountLimit(1,49811402)
    e1:SetCost(c49811402.imcost)
    e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
    e1:SetTarget(c49811402.imtg)
    e1:SetOperation(c49811402.imop)
    c:RegisterEffect(e1)
    --spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(49811402,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,49811402)
    e2:SetCost(aux.bfgcost)
    e2:SetTarget(c49811402.sptg)
    e2:SetOperation(c49811402.spop)
    c:RegisterEffect(e2)
end
function c49811402.imcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsReleasable() end
    Duel.Release(e:GetHandler(),REASON_COST)
end
function c49811402.imtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFlagEffect(tp,49811402)==0 end
end
function c49811402.efftg(e,c)
    return c:IsLevel(3) and c:IsRace(RACE_FIEND)
end
function c49811402.imop(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetTarget(c49811402.efftg)
    e1:SetValue(1)
    e1:SetReset(RESET_PHASE+PHASE_END,2)
    local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetTarget(c49811402.efftg)
    e2:SetValue(1)
    e2:SetReset(RESET_PHASE+PHASE_END,2)
    Duel.RegisterFlagEffect(tp,49811402,RESET_PHASE+PHASE_END,0,2)
    Duel.RegisterEffect(e1,tp)
    Duel.RegisterEffect(e2,tp)
end
function c49811402.spfilter(c,e,tp)
    return c:IsCode(52860176) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c49811402.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c49811402.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c49811402.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local res=0
    if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c49811402.spfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
        if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_CANNOT_TRIGGER)
            e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
            e1:SetDescription(aux.Stringid(49811402,2))
            e1:SetCondition(c49811402.actcon)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD)
            tc:RegisterEffect(e1)
        end
    end
end
function c49811402.actfilter(c)
    return c:IsRace(RACE_FIEND) and c:IsAttribute(ATTRIBUTE_DARK) and not c:IsSummonableCard()
end
function c49811402.actcon(e)
    local tp=e:GetHandlerPlayer()
    return not Duel.IsExistingMatchingCard(c49811402.actfilter,tp,LOCATION_MZONE,0,1,nil)
end