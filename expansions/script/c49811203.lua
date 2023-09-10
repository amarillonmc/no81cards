--図書館の稼動回路
function c49811203.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetDescription(aux.Stringid(49811203,0))
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c49811203.target)
    e1:SetOperation(c49811203.activate)
    c:RegisterEffect(e1)
    --discard & draw
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW)
    e2:SetDescription(aux.Stringid(49811203,1))
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCost(aux.bfgcost)
    e2:SetCondition(c49811203.condition)
    e2:SetTarget(c49811203.drtarget)
    e2:SetOperation(c49811203.operation)
    c:RegisterEffect(e2)
end
function c49811203.filter(c)
    return c:IsCode(70791313)
end
function c49811203.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c49811203.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c49811203.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c49811203.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c49811203.cfilter(c)
    return c:IsFaceup() and c:IsCode(70791313)
end
function c49811203.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c49811203.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c49811203.drtarget(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)
        and Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c49811203.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
    local g=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
        Duel.BreakEffect()
        Duel.Draw(tp,1,REASON_EFFECT)
    end
end