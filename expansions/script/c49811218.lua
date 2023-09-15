--角獣の予言
function c49811218.initial_effect(c)
    --activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DECKDES)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,49811218)
    e1:SetTarget(c49811218.target)
    e1:SetOperation(c49811218.activate)
    c:RegisterEffect(e1)
    --remove
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(49811218,0))
    e2:SetCategory(CATEGORY_REMOVE)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_REMOVE)
    e2:SetCountLimit(1,49811219)
    e2:SetCondition(c49811218.rmcon)
    e2:SetTarget(c49811218.rmtg)
    e2:SetOperation(c49811218.rmop)
    c:RegisterEffect(e2)
end
function c49811218.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1)
        and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_DECK,0,1,nil) end
end
function c49811218.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.IsPlayerCanDiscardDeck(tp,1) then
        Duel.ConfirmDecktop(tp,1)
        local g=Duel.GetDecktopGroup(tp,1)
        local tc=g:GetFirst()
        if tc:IsType(TYPE_SPELL) and tc:IsAbleToHand() then
            Duel.DisableShuffleCheck()
            Duel.SendtoHand(tc,nil,REASON_EFFECT)
            Duel.ShuffleHand(tp)
        else
            Duel.DisableShuffleCheck()
            Duel.SendtoGrave(tc,REASON_EFFECT+REASON_REVEAL)
        end
    end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
    e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
    e1:SetTarget(c49811218.rmtarget)
    e1:SetTargetRange(0xff,0xff)
    e1:SetValue(LOCATION_REMOVED)
    e1:SetReset(RESET_PHASE+PHASE_END,2)
    Duel.RegisterEffect(e1,tp)
end
function c49811218.rmtarget(e,c)
    return c:IsType(TYPE_SPELL)
end
function c49811218.cfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsRace(RACE_BEAST) and c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)
end
function c49811218.rmcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c49811218.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c49811218.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
    if chk==0 then return g:GetCount()>0 end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c49811218.rmop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
    if g:GetCount()>0 then
        Duel.HintSelection(g)
        Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
    end
end