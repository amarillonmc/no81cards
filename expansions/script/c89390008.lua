--被诅咒的斗士
local m=89390008
local cm=_G["c"..m]
function cm.initial_effect(c)
    local e0=Effect.CreateEffect(c)
    e0:SetDescription(aux.Stringid(m,1))
    e0:SetCategory(CATEGORY_REMOVE)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    e0:SetCountLimit(1,m)
    e0:SetCost(cm.cost)
    e0:SetTarget(cm.target0)
    e0:SetOperation(cm.activate0)
    c:RegisterEffect(e0)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,0))
    e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SEARCH+CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,m)
    e1:SetCost(cm.cost)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.activate)
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
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.GetCurrentPhase()==PHASE_END or Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,c) end
    if Duel.GetCurrentPhase()~=PHASE_END then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
        local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,c)
        Duel.Remove(g,POS_FACEUP,REASON_COST)
    end
end
function cm.spfilter(c,g)
    return c:IsType(TYPE_MONSTER) and not (g and g:IsExists(Card.IsCode,1,nil,c:GetCode())) and c:IsAbleToRemove()
end
function cm.target0(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local sg=Duel.GetFieldGroup(tp,LOCATION_REMOVED,0):Filter(Card.IsFaceup,nil)
        return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,sg)
    end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function cm.activate0(e,tp,eg,ep,ev,re,r,rp)
    local sg=Duel.GetFieldGroup(tp,LOCATION_REMOVED,0):Filter(Card.IsFaceup,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,sg)
    if g and g:GetCount()>0 then
        Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
    end
end
function cm.tgfilter(c,tp)
    return c:IsRace(RACE_PSYCHO) and c:IsAbleToRemove() and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,c,c:GetCode())
end
function cm.thfilter(c,code)
    return c:IsCode(code) and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil,tp) end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
    local tc=g:GetFirst()
    if tc and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_REMOVED) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local sg=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode())
        if sg:GetCount()>0 then
            Duel.SendtoHand(sg,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,sg)
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
