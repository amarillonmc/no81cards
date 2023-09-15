--二角獣の使い魔
function c49811210.initial_effect(c)
    --to hand
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(49811210,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
    e1:SetCountLimit(1,49811210)
    e1:SetCost(c49811210.thcost)
    e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
    e1:SetTarget(c49811210.thtg)
    e1:SetOperation(c49811210.thop)
    c:RegisterEffect(e1)
    --to grave
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(49811210,1))
    e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,49811211)
    e2:SetCost(aux.bfgcost)
    e2:SetCondition(c49811210.tgcon)
    e2:SetTarget(c49811210.tgtg)
    e2:SetOperation(c49811210.tgop)
    c:RegisterEffect(e2)
end
function c49811210.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsReleasable() end
    Duel.Release(e:GetHandler(),REASON_COST)
end
function c49811210.thfilter(c)
    return c:IsLevelBelow(5) and c:IsRace(RACE_BEAST) and c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsType(TYPE_TUNER)
end
function c49811210.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c49811210.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c49811210.thop(e,tp,eg,ep,ev,re,r,rp)
    c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c49811210.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,0)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetTarget(c49811210.splimit)
    Duel.RegisterEffect(e1,tp)
end
function c49811210.splimit(e,c)
    return c:IsLocation(LOCATION_EXTRA) and not c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c49811210.tgfilter(c,tp)
    return c:IsPreviousLocation(LOCATION_DECK) and c:IsPreviousControler(tp)
end
function c49811210.tgcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c49811210.tgfilter,1,nil,1-tp)
end
function c49811210.cfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_SPELL)
end
function c49811210.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local ct=Duel.GetMatchingGroupCount(c49811210.cfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
        if chk==0 then return ct>0 and Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>=ct and Duel.IsPlayerCanDiscardDeck(1-tp,ct) end
    Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,1-tp,ct)
end
function c49811210.tgop(e,tp,eg,ep,ev,re,r,rp)
    local ct=Duel.GetMatchingGroupCount(c49811210.cfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
    if ct>0 then
        Duel.DiscardDeck(1-tp,ct,REASON_EFFECT)
    end
end