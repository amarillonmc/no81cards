--心神不宁的炼金术师
local m=89390005
local cm=_G["c"..m]
function cm.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_CHAINING)
    e1:SetCondition(cm.condition)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.operation)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetCode(EVENT_REMOVE)
    e2:SetOperation(cm.regop)
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
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
    return rp==1-tp
end
function cm.filter1(c)
    return c:IsRace(RACE_PSYCHO) and c:IsAbleToRemove() and not c:IsPublic() and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_DECK,0,1,nil,c)
end
function cm.filter2(c,mc)
    return c:IsType(TYPE_MONSTER) and not c:IsAttribute(mc:GetAttribute()) and c:IsAbleToRemove()
end
function cm.filter3(c,mc)
    return c:IsCode(mc:GetCode()) and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_HAND,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,tp,LOCATION_HAND+LOCATION_DECK)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
    local g1=Duel.SelectMatchingCard(tp,cm.filter1,tp,LOCATION_HAND,0,1,1,nil)
    if g1:GetCount()==0 then return end
    Duel.ConfirmCards(1-tp,g1)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g2=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_DECK,0,1,1,nil,g1:GetFirst())
    if g2:GetCount()~=0 and Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)>0 and Duel.Remove(g2,POS_FACEUP,REASON_EFFECT)>0 then
        local tc=g2:GetFirst()
        if tc:IsRace(RACE_PSYCHO) and Duel.IsExistingMatchingCard(cm.filter3,tp,LOCATION_DECK,0,1,nil,tc) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
            local g3=Duel.SelectMatchingCard(tp,cm.filter3,tp,LOCATION_DECK,0,1,1,nil,tc)
            if g3:GetCount()>0 then
                Duel.SendtoHand(g3,nil,REASON_EFFECT)
                Duel.ConfirmCards(1-tp,g3)
            end
        end
    end
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetFlagEffect(m)>0
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToHand() end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SendtoHand(c,nil,REASON_EFFECT)
    end
end
function cm.handcon(e)
    return Duel.GetCurrentChain()==1
end
