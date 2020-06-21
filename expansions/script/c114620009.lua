--世纪末-铁皮引擎
local m=114620009
local cm=_G["c"..m]
function cm.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DRAW+CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCondition(cm.condition)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.activate)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,m)
    e2:SetCondition(cm.rmcondition)
    e2:SetCost(aux.bfgcost)
    e2:SetTarget(cm.thtg)
    e2:SetOperation(cm.thop)
    c:RegisterEffect(e2)
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e0:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
    c:RegisterEffect(e0)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetCurrentChain()~=0 then return false end
    if Duel.GetTurnPlayer()==tp then
        if c:IsHasEffect(114620005) then return true end
        return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
    else
        if c:IsHasEffect(114620005) then return c:IsLocation(LOCATION_HAND) end
        return false
    end
end
function cm.cfilter(c)
    return c:IsSetCard(0xe6f) and c:IsDestructable()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) and Duel.IsPlayerCanDraw(tp,2) end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_HAND)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_HAND,0,1,nil)
    if g:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
        local sg=g:Select(tp,1,1,nil)
        if Duel.Destroy(sg,REASON_EFFECT)>0 then Duel.Draw(tp,2,REASON_EFFECT) end
    end
end
function cm.rmcondition(e,tp,eg,ep,ev,re,r,rp)
    return not e:GetHandler():IsHasEffect(114620011)
end
function cm.thfilter(c)
    return c:IsSetCard(0xe6f) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,3,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)
    if g:GetCount()>=3 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
        local sg=g:Select(tp,3,3,nil)
        Duel.ConfirmCards(1-tp,sg)
        Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
        local tg=sg:Select(1-tp,1,1,nil)
        Duel.SendtoHand(tg,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,tg)
    end
end
