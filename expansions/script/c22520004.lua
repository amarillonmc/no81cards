--裏切者の獄獣　アムールユダ
local m=22520004
local cm=_G["c"..m]
function cm.initial_effect(c)
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_HAND)
    e2:SetCondition(cm.spcon1)
    e2:SetCost(cm.thcost1)
    e2:SetTarget(cm.rmtg)
    e2:SetOperation(cm.rmop)
    c:RegisterEffect(e2)
    local e1=e2:Clone()
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCondition(cm.spcon2)
    c:RegisterEffect(e1)
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_TODECK+CATEGORY_DESTROY+CATEGORY_REMOVE)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetCountLimit(1,m)
    e3:SetCondition(cm.spcon1)
    e3:SetTarget(cm.tdtg)
    e3:SetOperation(cm.tdop)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetCondition(cm.spcon2)
    c:RegisterEffect(e4)
end
function cm.spcon1(e,tp,eg,ep,ev,re,r,rp)
    return not Duel.IsPlayerAffectedByEffect(tp,22520006)
end
function cm.spcon2(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsPlayerAffectedByEffect(tp,22520006)
end
function cm.thcost1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function cm.filter(c,atk)
    return c:IsFaceup() and c:IsAttackBelow(atk-1)
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local atk=e:GetHandler():GetAttack()
    if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,atk) end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,LOCATION_MZONE)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
    local atk=e:GetHandler():GetAttack()
    local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,atk)
    if g:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
        local sg=g:Select(tp,1,1,nil)
        Duel.HintSelection(sg)
        Duel.Destroy(sg,REASON_EFFECT)
    end
end
function cm.tdfilter(c)
    return c:IsFacedown() and c:IsAbleToDeck()
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_REMOVED) and cm.tdfilter(chkc) end
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingTarget(cm.tdfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) and Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and c:IsAbleToRemove() end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,cm.tdfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,99,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,LOCATION_ONFIELD)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,1,0,0)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    if c:IsRelateToEffect(e) and tg:GetCount()>0 and Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 and tg:IsExists(Card.IsLocation,1,nil,LOCATION_DECK+LOCATION_EXTRA) then
        local n=tg:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
        local g=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,n,nil)
        if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)>0 then
            Duel.BreakEffect()
            Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
        end
    end
end
