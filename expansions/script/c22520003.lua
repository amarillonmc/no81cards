--辺獄の高僧　カラノス
local m=22520003
local cm=_G["c"..m]
function cm.initial_effect(c)
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_TOHAND)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e5:SetProperty(EFFECT_FLAG_DELAY)
    e5:SetCode(EVENT_TO_GRAVE)
    e5:SetCountLimit(1,m)
    e5:SetTarget(cm.thtg)
    e5:SetOperation(cm.thop)
    c:RegisterEffect(e5)
    local e0=Effect.CreateEffect(c)
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
function cm.thfilter(c)
    return not c:IsCode(m) and c:IsSetCard(0xec1) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
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
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and aux.NegateEffectMonsterFilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(aux.NegateEffectMonsterFilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
    Duel.SelectTarget(tp,aux.NegateEffectMonsterFilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
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
    if tc:IsFaceup() and not tc:IsDisabled() and tc:IsRelateToEffect(e) then
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
    end
end
function cm.indcon(e)
    local c=e:GetLabelObject()
    return c:GetFlagEffectLabel(m)==e:GetLabel()
end
