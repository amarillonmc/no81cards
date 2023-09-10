--無声なサイコフィールド
function c49811205.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOGRAVE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetOperation(c49811205.activate)
    c:RegisterEffect(e1)
    --To hand
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(49811205,1))
    e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SUMMON)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCode(EVENT_REMOVE)
    e2:SetCountLimit(2,49811205)
    e2:SetCondition(c49811205.thcon)
    e2:SetTarget(c49811205.thtg)
    e2:SetOperation(c49811205.thop)
    c:RegisterEffect(e2)
end
function c49811205.tgfilter(c)
    return c:IsType(TYPE_TUNER) and c:IsRace(RACE_PSYCHO) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsAbleToGrave()
end
function c49811205.activate(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c49811205.tgfilter,tp,LOCATION_DECK,0,nil)
    if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(49811205,0)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
        local sg=g:Select(tp,1,1,nil)
        Duel.SendtoGrave(sg,REASON_EFFECT)
    end
end
function c49811205.cfilter(c,tp)
    return c:IsFaceup() and c:IsRace(RACE_PSYCHO)
end
function c49811205.thcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c49811205.cfilter,1,nil)
end
function c49811205.thfilter(c)
    return c:IsRace(RACE_PSYCHO) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsAbleToHand() and not c:IsType(TYPE_TUNER)
end
function c49811205.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c49811205.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
    Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,0,0,0)
end
function c49811205.sumfilter(c)
    return c:IsSummonable(true,nil) and c:IsRace(RACE_PSYCHO)
end
function c49811205.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c49811205.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
        if Duel.IsExistingMatchingCard(c49811205.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil)
            and Duel.SelectYesNo(tp,aux.Stringid(49811205,2)) then
            Duel.BreakEffect()
            Duel.ShuffleHand(tp)
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
            local sg=Duel.SelectMatchingCard(tp,c49811205.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
            if sg:GetCount()>0 then
                Duel.Summon(tp,sg:GetFirst(),true,nil)
            end
        end
    end
end