--愛慕の天使　カヴァン
local m=22520002
local cm=_G["c"..m]
function cm.initial_effect(c)
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_HAND)
    e2:SetCondition(cm.spcon1)
    e2:SetCost(cm.thcost)
    e2:SetTarget(cm.thtg)
    e2:SetOperation(cm.thop)
    c:RegisterEffect(e2)
    local e1=e2:Clone()
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCondition(cm.spcon2)
    c:RegisterEffect(e1)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetCountLimit(1,m)
    e3:SetTarget(aux.TargetBoolFunction(aux.IsCodeListed,22520013))
    e3:SetTargetRange(LOCATION_HAND,0)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EFFECT_TRAP_ACT_IN_HAND)
    c:RegisterEffect(e4)
end
function cm.spcon1(e,tp,eg,ep,ev,re,r,rp)
    return not Duel.IsPlayerAffectedByEffect(tp,22520006)
end
function cm.spcon2(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsPlayerAffectedByEffect(tp,22520006)
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsDiscardable() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function cm.thfilter(c)
    return (c:IsSetCard(0xec1) and not c:IsCode(m) and c:IsType(TYPE_MONSTER) or aux.IsCodeListed(c,22520013) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsType(TYPE_QUICKPLAY)) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
