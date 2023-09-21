--相剣大君－湛盧
function c49811222.initial_effect(c)
    --synchro summon
    aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsRace,RACE_WYRM),1)
    c:EnableReviveLimit()
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(49811222,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCountLimit(1,49811222)
    e1:SetCondition(c49811222.spcon)
    e1:SetTarget(c49811222.sptg)
    e1:SetOperation(c49811222.spop)
    c:RegisterEffect(e1)
    --remove
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetDescription(aux.Stringid(49811222,1))
    e2:SetCategory(CATEGORY_REMOVE)
    e2:SetCountLimit(1,49811223)
    e2:SetCost(c49811222.cost)
    e2:SetTarget(c49811222.rmtg)
    e2:SetOperation(c49811222.rmop)
    c:RegisterEffect(e2)
end
function c49811222.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c49811222.spfilter(c,e,tp)
    return c:IsRace(RACE_WYRM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c49811222.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c49811222.spfilter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c49811222.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp)
        and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_HAND,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c49811222.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND)
end
function c49811222.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if not tc:IsRelateToEffect(e) then return end
    local res=Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
    Duel.SpecialSummonComplete()
    local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_HAND,0,nil)
    if res and #g>0 then
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
        local tg=g:Select(tp,1,1,nil)
        Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
    end
end
function c49811222.cfilter(c,e,tp)
    local attr=c:GetAttribute()
    return c:IsRace(RACE_WYRM) and c:IsAbleToRemoveAsCost()
        and Duel.IsExistingMatchingCard(c49811222.rmfilter,tp,0,LOCATION_GRAVE,1,nil,attr,e,tp)
end
function c49811222.rmfilter(c,attr,e,tp)
    return c:GetAttribute()==attr
        and c:IsAbleToRemove(c:GetControler(),POS_FACEUP,REASON_EFFECT)
end
function c49811222.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        e:SetLabel(100)
        return Duel.IsExistingMatchingCard(c49811222.cfilter,tp,LOCATION_GRAVE,0,1,nil,tp)
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local cost=Duel.SelectMatchingCard(tp,c49811222.cfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
    e:SetLabel(cost:GetAttribute())
    Duel.Remove(cost,POS_FACEUP,REASON_COST)
end
function c49811222.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then
        if e:GetLabel()~=100 then return false end
        e:SetLabel(0)
        return true
    end
    local g=Duel.GetMatchingGroup(c49811222.rmfilter,tp,0,LOCATION_GRAVE,nil,type)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,0)
end
function c49811222.rmop(e,tp,eg,ep,ev,re,r,rp)
    local attr=e:GetLabel()
    local g=Duel.GetMatchingGroup(c49811222.rmfilter,1-tp,LOCATION_GRAVE,0,nil,attr)
    if g:GetCount()>0 then
        Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
    end
end