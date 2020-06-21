--与彗星的邂逅
local m=89388005
local cm=_G["c"..m]
function cm.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DRAW+CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.activate)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,m)
    e2:SetTarget(cm.tdtg)
    e2:SetOperation(cm.tdop)
    c:RegisterEffect(e2)
end
function cm.cfilter(c)
    return c:IsSetCard(0xcc20) and c:IsDestructable() and (c:IsFaceup() or c:IsLocation(LOCATION_HAND))
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler()) and Duel.IsPlayerCanDraw(tp,2) end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,e:GetHandler())
    if g:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
        local sg=g:Select(tp,1,1,nil)
        if Duel.Destroy(sg,REASON_EFFECT)>0 then Duel.Draw(tp,2,REASON_EFFECT) end
    end
end
function cm.setfilter(c)
    return c:IsSetCard(0xcc20) and c:IsAbleToGrave()
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToHand() and Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g and g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)>0 then
        Duel.SendtoHand(c,nil,REASON_EFFECT)
    end
end
