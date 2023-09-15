--三角獣の使い魔
function c49811212.initial_effect(c)
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(49811212,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,49811212)
    e1:SetTarget(c49811212.sptg)
    e1:SetOperation(c49811212.spop)
    c:RegisterEffect(e1)
    --banish
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(49811212,1))
    e2:SetCategory(CATEGORY_REMOVE)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,49811213)
    e2:SetCost(aux.bfgcost)
    e2:SetCondition(c49811212.rmcon)
    e2:SetTarget(c49811212.rmtg)
    e2:SetOperation(c49811212.rmop)
    c:RegisterEffect(e2)
end
function c49811212.spfilter(c,e,tp)
    return c:IsRace(RACE_BEAST) and c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c49811212.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c=e:GetHandler()
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c49811212.spfilter(chkc,e,tp) end
    if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
        and Duel.IsExistingTarget(c49811212.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c49811212.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    g:AddCard(c)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,2,0,0)
end
function c49811212.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
        and not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 then
        local g=Group.FromCards(c,tc)
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,0)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetTarget(c49811212.splimit)
    Duel.RegisterEffect(e1,tp)
end
function c49811212.splimit(e,c)
    return c:IsLocation(LOCATION_EXTRA) and not c:IsType(TYPE_SYNCHRO)
end
function c49811212.rmfilter(c,tp)
    return c:IsPreviousLocation(LOCATION_DECK) and c:IsPreviousControler(tp)
end
function c49811212.rmcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c49811212.rmfilter,1,nil,1-tp)
end
function c49811212.cfilter(c)
    return c:IsType(TYPE_SPELL) and c:IsAbleToRemove()
end
function c49811212.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c49811212.cfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c49811212.rmop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c49811212.cfilter,tp,LOCATION_DECK,0,1,1,nil)
    local tg=g:GetFirst()
    if tg==nil then return end
    Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
end