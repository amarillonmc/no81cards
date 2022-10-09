local m=4865013
local cm=_G["c"..m] 
function cm.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK+CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_CHAINING)
    e1:SetCondition(cm.condition)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.activate)
    c:RegisterEffect(e1)
end
function cm.cfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x332b)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
        and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
    end
end
function cm.desfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x332b)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    local ec=re:GetHandler()
    if Duel.NegateActivation(ev) and ec:IsRelateToEffect(re) then
        ec:CancelToGrave()
        if Duel.SendtoDeck(ec,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 and ec:IsLocation(LOCATION_DECK+LOCATION_EXTRA) then
            local g=Duel.GetMatchingGroup(cm.desfilter,tp,LOCATION_ONFIELD,0,aux.ExceptThisCard(e))
            if g:GetCount()>0 then
                Duel.BreakEffect()
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
                local sg=g:Select(tp,1,1,nil)
                Duel.Destroy(sg,REASON_EFFECT)
            end
        end
    end
end
