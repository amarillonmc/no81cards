--メンタルインフィニティ・デーモン
function c49811208.initial_effect(c)
    --synchro summon
    aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_PSYCHO),aux.NonTuner(nil),1)
    c:EnableReviveLimit()
    --can not attack
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e1:SetTarget(c49811208.atktg)
    e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    c:RegisterEffect(e1)
    --release
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(49811208,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,49811208)
    e2:SetCondition(c49811208.spcon)
    e2:SetCost(c49811208.spcost)
    e2:SetTarget(c49811208.sptg)
    e2:SetOperation(c49811208.spop)
    c:RegisterEffect(e2)
    --tograve
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(49811208,2))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_REMOVE)
    e3:SetCountLimit(1,49811209)
    e3:SetTarget(c49811208.tgtg)
    e3:SetOperation(c49811208.tgop)
    c:RegisterEffect(e3)
end
function c49811208.atktg(e,c)
    return c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:IsSummonLocation(LOCATION_EXTRA+LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE)
end
function c49811208.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c49811208.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsReleasable() end
    Duel.Release(e:GetHandler(),REASON_COST)
end
function c49811208.spfilter(c,e,tp,mc)
    return c:IsLevelBelow(9) and c:IsRace(RACE_PSYCHO) and c:IsType(TYPE_SYNCHRO)
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
        and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c49811208.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c49811208.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,e:GetHandler()) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c49811208.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c49811208.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,e:GetHandler())
    if g:GetCount()>0 then
        local tc=g:GetFirst()
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
        tc:RegisterFlagEffect(49811208,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e1:SetCode(EVENT_PHASE+PHASE_END)
        e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
        e1:SetCountLimit(1)
        e1:SetLabel(Duel.GetTurnCount())
        e1:SetLabelObject(tc)
        e1:SetCondition(c49811208.rmcon)
        e1:SetOperation(c49811208.rmop)
        e1:SetReset(RESET_PHASE+PHASE_END,2)
        Duel.RegisterEffect(e1,tp)
    end
end
function c49811208.rmcon(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetLabelObject()
    return tc:GetFlagEffect(49811208)~=0 and Duel.GetTurnCount()~=e:GetLabel()
end
function c49811208.rmop(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetLabelObject()
    Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
end
function c49811208.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,nil) end
    local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,2,0,0)
end
function c49811208.tgop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,2,nil)
    if g:GetCount()>0 then
        Duel.HintSelection(g)
        Duel.SendtoGrave(g,REASON_EFFECT)
    end
end