--海造贼-银胡子机关长
local m=89387022
local cm=_G["c"..m]
function cm.initial_effect(c)
    aux.AddLinkProcedure(c,cm.mfilter,1,1)
    c:EnableReviveLimit()
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCountLimit(1,m)
    e1:SetCondition(cm.thcon)
    e1:SetTarget(cm.thtg)
    e1:SetOperation(cm.thop)
    c:RegisterEffect(e1)
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e7:SetRange(LOCATION_GRAVE)
    e7:SetCode(EFFECT_SEND_REPLACE)
    e7:SetCountLimit(1,m+100000000)
    e7:SetTarget(cm.reptg)
    e7:SetValue(aux.TRUE)
    c:RegisterEffect(e7)
end
function cm.mfilter(c)
    return c:IsLevelBelow(4) and c:IsLinkSetCard(0x13f)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.thfilter(c)
    return c:IsCode(93031067) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function cm.repfilter(c)
    return c:IsLocation(LOCATION_HAND) and c:GetReason(REASON_DISCARD)
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return eg:GetCount()==1 and eg:IsExists(cm.repfilter,1,nil) and e:GetHandler():IsAbleToRemove() and tp==re:GetHandlerPlayer() and re:IsActivated() and re:GetHandler():IsSetCard(0x13f) end
    if Duel.SelectEffectYesNo(tp,e:GetHandler()) then
        Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_REPLACE)
        return true
    end
    return false
end
