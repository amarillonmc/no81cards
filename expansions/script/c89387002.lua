--伯吉斯异兽·马尔海蝎
local m=89387002
local cm=_G["c"..m]
function cm.initial_effect(c)
    aux.AddLinkProcedure(c,cm.matfilter,1,1)
    c:EnableReviveLimit()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(cm.efilter)
    c:RegisterEffect(e1)
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_DECKDES)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetCountLimit(1,m)
    e3:SetTarget(cm.settg)
    e3:SetOperation(cm.setop)
    c:RegisterEffect(e3)
end
function cm.matfilter(c)
    return c:GetOriginalType()&TYPE_TRAP>0
end
function cm.efilter(e,re)
    return re:IsActiveType(TYPE_MONSTER) and re:GetOwner()~=e:GetOwner()
end
function cm.setfilter(c,tp)
    return c:IsType(TYPE_TRAP) and c:IsSetCard(0xd4) and c:IsSSetable() and Duel.IsExistingMatchingCard(cm.setfilter2,tp,LOCATION_DECK,0,1,nil,c)
end
function cm.setfilter2(c,tc)
    return not c:IsCode(tc:GetCode()) andc:IsType(TYPE_TRAP) and c:IsSetCard(0xd4) and c:IsAbleToGrave()
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and cm.setfilter(chkc,tp) end
    if chk==0 then return Duel.IsExistingTarget(cm.setfilter,tp,LOCATION_REMOVED,0,1,nil,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
    local g=Duel.SelectTarget(tp,cm.setfilter,tp,LOCATION_REMOVED,0,1,1,nil,tp)
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.SSet(tp,tc)>0 then
        local e0=Effect.CreateEffect(e:GetHandler())
        e0:SetType(EFFECT_TYPE_SINGLE)
        e0:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
        e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
        e0:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e0)
        local fid=e:GetHandler():GetFieldID()
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e1:SetCode(EVENT_PHASE+PHASE_END)
        e1:SetCountLimit(1)
        if Duel.GetTurnPlayer()==tp then
            e1:SetLabel(0)
            e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
        else
            e1:SetLabel(Duel.GetTurnCount())
            e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
        end
        e1:SetLabelObject(tc)
        e1:SetValue(fid)
        e1:SetCondition(cm.rmcon)
        e1:SetOperation(cm.rmop)
        Duel.RegisterEffect(e1,tp)
        tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1,fid)
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
        local g=Duel.SelectMatchingCard(tp,cm.setfilter2,tp,LOCATION_DECK,0,1,1,nil,tc)
        if g and g:GetCount()>0 then
            Duel.SendtoGrave(g,REASON_EFFECT)
        end
    end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetTargetRange(1,0)
    e1:SetTarget(cm.splimit)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function cm.rmcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnCount()~=e:GetLabel() and Duel.GetTurnPlayer()~=tp
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetLabelObject()
    if tc:GetFlagEffectLabel(m)==e:GetValue() then
        Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
    end
end
function cm.splimit(e,c)
    return not c:IsAttribute(ATTRIBUTE_WATER)
end
