--彗星再生机构
local m=89388006
local cm=_G["c"..m]
function cm.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.activate)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_DESTROYED)
    e2:SetCountLimit(1,m)
    e2:SetCondition(cm.setcon)
    e2:SetTarget(cm.settg)
    e2:SetOperation(cm.setop)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetCountLimit(1,m+100000000)
    e3:SetCost(cm.spcost)
    e3:SetTarget(cm.tdtg)
    e3:SetOperation(cm.tdop)
    c:RegisterEffect(e3)
    Duel.AddCustomActivityCounter(m,ACTIVITY_CHAIN,cm.chainfilter)
end
function cm.chainfilter(re,tp,cid)
    return re:GetHandler():IsSetCard(0xcc20)
end
function cm.filter(c)
    return c:IsSetCard(0xcc20) and c:IsAbleToHand()
end
function cm.desfilter(c)
    return c:IsSetCard(0xcc20) and c:IsDestructable()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(cm.desfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler()) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
        local dg=Duel.SelectMatchingCard(tp,cm.desfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,c)
        if not dg or dg:GetCount()==0 then return end
        Duel.BreakEffect()
        Duel.Destroy(dg,REASON_EFFECT)
    end
end
function cm.setcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsReason(REASON_EFFECT)
end
function cm.setfilter(c)
    return c:IsSetCard(0xcc20) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
    local g=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SSet(tp,g:GetFirst())
    end
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetCustomActivityCount(m,tp,ACTIVITY_CHAIN)==0 end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_CANNOT_ACTIVATE)
    e1:SetTargetRange(1,0)
    e1:SetValue(cm.aclimit)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function cm.aclimit(e,re,tp)
    return not re:GetHandler():IsSetCard(0xcc20)
end
function cm.thfilter(c)
    return c:IsSetCard(0xcc20) and c:IsAbleToDeck()
end
function cm.thfilter2(c)
    return c:IsSetCard(0xcc20) and c:IsType(TYPE_PENDULUM) and c:IsFaceup() and c:IsAbleToDeck()
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsAbleToHand() and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_GRAVE,0,1,c) and Duel.IsExistingMatchingCard(cm.thfilter2,tp,LOCATION_EXTRA,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,LOCATION_GRAVE+LOCATION_EXTRA,2)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_GRAVE,0,1,1,c)
    if not g or g:GetCount()==0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local sg=Duel.SelectMatchingCard(tp,cm.thfilter2,tp,LOCATION_EXTRA,0,1,1,nil)
    if not sg or sg:GetCount()==0 then return end
    g:Merge(sg)
    if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)>0 then
        Duel.SendtoHand(c,nil,REASON_EFFECT)
    end
end
