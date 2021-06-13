--对邪魂兵器 时空回旋机
local m=30001007
local cm=_G["c"..m]
function cm.initial_effect(c)
    c:EnableReviveLimit()
    c:SetSPSummonOnce(m)
    aux.AddLinkProcedure(c,nil,2,3)
    --Remove
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,0))
    e1:SetCategory(CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCost(cm.rmcost)
    e1:SetTarget(cm.rmtg)
    e1:SetOperation(cm.rmop)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetHintTiming(0,TIMING_REMOVE+TIMING_END_PHASE)
    e2:SetRange(LOCATION_REMOVED)
    e2:SetCountLimit(1)
    e2:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
        local mg=Duel.GetMatchingGroup(Card.IsAbleToDeckOrExtraAsCost,tp,LOCATION_REMOVED,LOCATION_REMOVED,e:GetHandler())
        if chk==0 then return mg:GetCount()>=7 end
        local g=mg:Select(tp,7,7,nil)
        Duel.SendtoDeck(g,nil,2,REASON_COST)
    end)
    e2:SetTarget(cm.sptg)
    e2:SetOperation(cm.spop)
    c:RegisterEffect(e2)   
end
function cm.rmfilter(c,e,tp)
    return c:IsAbleToRemoveAsCost() and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsSetCard(0x920) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_DECK,0,1,c)
end
function cm.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.rmfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,cm.rmfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_DECK,0,1,nil) end
    local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_DECK,0,nil)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function cm.rmop(e,tp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        if Duel.Remove(g,POS_FACEUP,REASON_EFFECT) then
            local tc=Duel.GetOperatedGroup():GetFirst()
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
            e1:SetRange(LOCATION_REMOVED)
            e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
            e1:SetCountLimit(1)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
            e1:SetCondition(cm.thcon)
            e1:SetOperation(cm.thop)
            e1:SetLabel(0)
            tc:RegisterEffect(e1)
        end
    end
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
    local ct=e:GetLabel()
    e:GetHandler():SetTurnCounter(ct+1)
    if ct==1 then
        Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,e:GetHandler())
    else e:SetLabel(1) end
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsRelateToEffect(e) then
        Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
    end
end