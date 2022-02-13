--魔術師の獄獣　フウチョウ
local m=22520001
local cm=_G["c"..m]
function cm.initial_effect(c)
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(cm.spcon1)
    e2:SetCost(cm.cost)
    e2:SetTarget(cm.target)
    e2:SetOperation(cm.operation)
    c:RegisterEffect(e2)
    local e1=e2:Clone()
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCondition(cm.spcon2)
    c:RegisterEffect(e1)
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_REMOVE+CATEGORY_DRAW)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e3:SetCountLimit(1,m)
    e3:SetCondition(cm.actcon)
    e3:SetTarget(cm.acttarget)
    e3:SetOperation(cm.actactivate)
    c:RegisterEffect(e3)
end
function cm.spcon1(e,tp,eg,ep,ev,re,r,rp)
    return not Duel.IsPlayerAffectedByEffect(tp,22520006)
end
function cm.spcon2(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsPlayerAffectedByEffect(tp,22520006)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsReleasable() end
    Duel.Release(e:GetHandler(),REASON_COST)
end
function cm.filter(c)
    return c:IsCode(22520006) and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function cm.actcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,22520006)
end
function cm.acttarget(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,2) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_HAND,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function cm.actactivate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local tg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_HAND,0,1,1,nil)
    if tg:GetCount()>0 then
        local tc=tg:GetFirst()
        if Duel.Remove(tg,POS_FACEDOWN,REASON_EFFECT)==0 or not tc:IsLocation(LOCATION_REMOVED) then return end
        Duel.BreakEffect()
        Duel.Draw(tp,2,REASON_EFFECT)
    end
end
