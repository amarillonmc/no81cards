--心神不宁的炼金术师
local m=89390005
local cm=_G["c"..m]
function cm.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,m)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.operation)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_REMOVE)
    e2:SetOperation(cm.rmop)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_TOHAND)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_PHASE+PHASE_END)
    e3:SetRange(LOCATION_REMOVED)
    e3:SetCountLimit(1,m)
    e3:SetCondition(cm.thcon)
    e3:SetTarget(cm.thtg)
    e3:SetOperation(cm.thop)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_TRAP_ACT_IN_HAND)
    e4:SetCondition(cm.handcon)
    c:RegisterEffect(e4)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_REMOVED,0,2,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_GRAVE)
end
function cm.tdfilter(c)
    return c:IsAbleToDeck() and c:IsRace(RACE_PSYCHO)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_REMOVED,0,2,2,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
        local f=Card.IsAbleToDeck
        if not g:IsExists(cm.tdfilter,1,nil) then f=cm.tdfilter end
        local sg=Duel.SelectMatchingCard(tp,f,tp,LOCATION_HAND,0,1,1,nil)
        if sg:GetCount()>0 then
            if f==cm.tdfilter then Duel.ConfirmCards(1-tp,sg) end
            Duel.ShuffleHand(tp)
            Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
        else
            Duel.SendtoGrave(Duel.GetFieldGroup(p,LOCATION_HAND,0),REASON_EFFECT)
        end
    end
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsFacedown() then return end
    e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetFlagEffect(m)~=0
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsAbleToHand() or c:IsSSetable() end
    Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        if c:IsAbleToHand() and (not c:IsSSetable() or Duel.SelectOption(tp,1190,1153)==0) then
            Duel.SendtoHand(c,nil,REASON_EFFECT)
        else
            Duel.SSet(tp,c)
        end
    end
end
function cm.handcon(e)
    return Duel.GetCurrentPhase()==PHASE_END
end
