--平行视界
function c60159916.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_TO_HAND)
    e1:SetCondition(c60159916.regcon)
    e1:SetOperation(c60159916.regop)
    c:RegisterEffect(e1)
    --Activate
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_REMOVE)
    e2:SetType(EFFECT_TYPE_ACTIVATE)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetCondition(c60159916.condition)
    e2:SetCost(c60159916.cost)
    e2:SetTarget(c60159916.target)
    e2:SetOperation(c60159916.activate)
    c:RegisterEffect(e2)
end
function c60159916.regcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return Duel.GetFlagEffect(tp,60159916)==0 and Duel.GetCurrentPhase()==PHASE_DRAW
        and c:IsReason(REASON_DRAW) and c:IsReason(REASON_RULE)
end
function c60159916.regop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.SelectYesNo(tp,aux.Stringid(60159916,0)) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_PUBLIC)
        e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_MAIN1)
        c:RegisterEffect(e1)
        c:RegisterFlagEffect(60159916,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_MAIN1,0,1)
    end
end
function c60159916.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetCurrentPhase()==PHASE_MAIN1 and not Duel.CheckPhaseActivity()
end
function c60159916.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():GetFlagEffect(60159916)~=0 end
end
function c60159916.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFlagEffect(tp,60159916)==0 
        and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_DECK,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,PLAYER_ALL,LOCATION_DECK)
end
function c60159916.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetFlagEffect(tp,60159916)~=0 then return end
    Duel.RegisterFlagEffect(tp,60159916,0,0,0)
    local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_DECK,LOCATION_DECK,nil)
    if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)>0 then
        Duel.BreakEffect()
        local g2=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_REMOVED,0,nil)
        local g3=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_REMOVED,nil)
        Duel.SendtoDeck(g2,1-tp,2,REASON_EFFECT)
        Duel.SendtoDeck(g3,tp,2,REASON_EFFECT)
    end
end
