--マドルチェ・グランセスール
function c84610019.initial_effect(c)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetCountLimit(1,84610019)
    e1:SetTarget(c84610019.sumtg)
    e1:SetOperation(c84610019.sumop)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2)
    --tohand+search
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
    e3:SetRange(LOCATION_HAND)
    e3:SetCountLimit(1,846100191)
    e3:SetCost(c84610019.cost)
    e3:SetTarget(c84610019.target)
    e3:SetOperation(c84610019.operation)
    c:RegisterEffect(e3)
    --to deck
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_TODECK)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetCondition(c84610019.retcon)
    e3:SetTarget(c84610019.rettg)
    e3:SetOperation(c84610019.retop)
    c:RegisterEffect(e3)
end
function c84610019.sumfilter(c)
    return c:IsSetCard(0x71) and not c:IsCode(84610019) and c:IsSummonable(true,nil)
end
function c84610019.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c84610019.sumfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c84610019.sumop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
        local g=Duel.SelectMatchingCard(tp,c84610019.sumfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
        local tc=g:GetFirst()
        if tc then
            Duel.Summon(tp,tc,true,nil)
        end
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_LEVEL)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        e1:SetValue(-1)
        tc:RegisterEffect(e1)
    end
    local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e2:SetReset(RESET_PHASE+PHASE_END)
    e2:SetTargetRange(1,0)
    e2:SetTarget(c84610019.splimit)
    Duel.RegisterEffect(e2,tp)
end
function c84610019.splimit(e,c,sump,sumtype,sumpos,targetp,se)
    return not c:IsSetCard(0x71)
end
function c84610019.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsDiscardable() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c84610019.filter(c)
    return c:IsSetCard(0x71) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c84610019.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c84610019.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c84610019.operation(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c84610019.filter,tp,LOCATION_DECK,0,nil)
    if g:GetCount()<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local sg1=g:Select(tp,1,1,nil)
    g:Remove(Card.IsCode,nil,sg1:GetFirst():GetCode())
    if g:GetCount()>0 and Duel.SelectYesNo(tp,210) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local sg2=g:Select(tp,1,1,nil)
        sg1:Merge(sg2)
    end
    ct=Duel.SendtoHand(sg1,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,sg1)
    if ct>0 then
        local tg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
        if tg:GetCount()>0 then
            Duel.BreakEffect()
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
            Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
        end
    end
end
function c84610019.retcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsReason(REASON_DESTROY) and e:GetHandler():GetReasonPlayer()==1-tp
        and e:GetHandler():GetPreviousControler()==tp
end
function c84610019.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c84610019.retop(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsRelateToEffect(e) then
        Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
    end
end
