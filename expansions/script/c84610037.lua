--水晶机巧挖矿
local m=84610037
local cm=_G["c"..m]
function cm.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCost(cm.cost)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.activate)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetCost(cm.setcost)
    e3:SetTarget(cm.settg)
    e3:SetOperation(cm.setop)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_TOGRAVE)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_REMOVE)
    e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
    e4:SetTarget(cm.tgtg)
    e4:SetOperation(cm.tgop)
    c:RegisterEffect(e4)
end
function cm.cfilter(c)
    return c:IsSetCard(0xea) and c:IsDiscardable()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return not c:IsStatus(STATUS_ACT_FROM_HAND) or Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND,0,1,c) end
    if c:IsStatus(STATUS_ACT_FROM_HAND) then
        Duel.DiscardHand(tp,cm.cfilter,1,1,REASON_COST,c)
    end
end
function cm.filter(c,e,tp)
    return c:IsSetCard(0xea) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.rdfilter(c)
    return c:IsSetCard(0xea) and c:IsAbleToDeck()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 and Duel.IsExistingMatchingCard(cm.rdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
        local sg=Duel.SelectMatchingCard(tp,cm.rdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
        if sg:GetCount()<=0 then return end
        Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
    end
end
function cm.setfilter(c)
    return c:IsSetCard(0xea) and c:IsAbleToRemoveAsCost()
end
function cm.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_GRAVE,0,2,c) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_GRAVE,0,2,2,c)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsSSetable() end
    Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SSet(tp,c)~=0 then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
        e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
        e1:SetValue(LOCATION_REMOVED)
        c:RegisterEffect(e1)
    end
end
function cm.rmfilter(c)
    return c:IsFaceup() and c:IsSetCard(0xea)
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c=e:GetHandler()
    if chkc then return chkc~=c and chkc:IsLocation(LOCATION_REMOVED) and cm.rmfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(cm.rmfilter,tp,LOCATION_REMOVED,0,3,c) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
    local g=Duel.SelectTarget(tp,cm.rmfilter,tp,LOCATION_REMOVED,0,3,3,c)
    g:AddCard(c)
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    local sg=tg:Filter(Card.IsRelateToEffect,nil,e)
    sg:AddCard(c)
    if sg:GetCount()>0 then
        Duel.SendtoGrave(sg,REASON_EFFECT+REASON_RETURN)
    end
end
