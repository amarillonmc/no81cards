--崇拝者の獄獣　イエイヌ
local m=22520000
local cm=_G["c"..m]
function cm.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,0))
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,m)
    e1:SetCondition(cm.actcon)
    e1:SetCost(cm.actcost)
    e1:SetTarget(cm.acttg)
    e1:SetOperation(cm.actop)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetCondition(cm.actcon2)
    c:RegisterEffect(e2)
    local e0=Effect.CreateEffect(c)
    e0:SetDescription(aux.Stringid(m,1))
    e0:SetType(EFFECT_TYPE_IGNITION)
    e0:SetRange(LOCATION_HAND)
    e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e0:SetCondition(cm.spcon1)
    e0:SetCost(cm.cost)
    e0:SetTarget(cm.negtg)
    e0:SetOperation(cm.operation)
    c:RegisterEffect(e0)
    local e3=e0:Clone()
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetCondition(cm.spcon2)
    c:RegisterEffect(e3)
end
function cm.actcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(Card.IsRace,tp,LOCATION_GRAVE,0,1,nil,RACE_FIEND) and not Duel.IsPlayerAffectedByEffect(tp,22520006)
end
function cm.actcon2(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(Card.IsRace,tp,LOCATION_GRAVE,0,1,nil,RACE_FIEND) and Duel.IsPlayerAffectedByEffect(tp,22520006)
end
function cm.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsDiscardable() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function cm.actfilter(c,tp)
    return c:IsCode(22520011) and c:GetActivateEffect():IsActivatable(tp,false,false)
end
function cm.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.actfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,tp) end
end
function cm.actop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
    local g=Duel.SelectMatchingCard(tp,cm.actfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,tp)
    local tc=g:GetFirst()
    if tc then
        local te=tc:GetActivateEffect()
        Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
        local tep=tc:GetControler()
        Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
    end
end
function cm.spcon1(e,tp,eg,ep,ev,re,r,rp)
    return not e:GetHandler():IsPublic() and not Duel.IsPlayerAffectedByEffect(tp,22520006)
end
function cm.spcon2(e,tp,eg,ep,ev,re,r,rp)
    return not e:GetHandler():IsPublic() and Duel.IsPlayerAffectedByEffect(tp,22520006)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:GetFlagEffect(m)==0 end
    c:RegisterFlagEffect(m,RESET_CHAIN,0,1)
end
function cm.negfilter(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP) and aux.NegateAnyFilter(c)
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and cm.negfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(cm.negfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
    local g=Duel.SelectTarget(tp,cm.negfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    local fid=c:GetFieldID()
    c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,fid,66)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_PUBLIC)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+PHASE_END)
    c:RegisterEffect(e1)
    local tc=Duel.GetFirstTarget()
    if ((tc:IsFaceup() and not tc:IsDisabled()) or tc:IsType(TYPE_TRAPMONSTER)) and tc:IsRelateToEffect(e) then
        Duel.NegateRelatedChain(tc,RESET_TURN_SET)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetLabel(fid)
        e1:SetLabelObject(c)
        e1:SetCondition(cm.indcon)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetValue(RESET_TURN_SET)
        tc:RegisterEffect(e2)
        if tc:IsType(TYPE_TRAPMONSTER) then
            local e3=e1:Clone()
            e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
            tc:RegisterEffect(e3)
        end
    end
end
function cm.indcon(e)
    local c=e:GetLabelObject()
    return c:GetFlagEffectLabel(m)==e:GetLabel()
end
