--Uni☆ties 超级组合
local m=89388025
local cm=_G["c"..m]
function cm.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TODECK+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.activate)
    c:RegisterEffect(e1)
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetCountLimit(1,m)
    e3:SetTarget(cm.tdtg)
    e3:SetOperation(cm.tdop)
    c:RegisterEffect(e3)
end
function cm.cfilter(c)
    return c:IsSetCard(0xcc22) and c:IsType(TYPE_MONSTER)
end
function cm.tgfilter(c,tp)
    return c:IsSetCard(0xcc22) and c:IsFaceup() and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,1,c)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingTarget(cm.tgfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=Duel.SelectTarget(tp,cm.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
    Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DEFCHANGE,g,1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,1,1,tc)
    if not g or g:GetCount()==0 then return end
    Duel.ConfirmCards(1-tp,g)
    local dc=g:GetFirst()
    if tc:IsRelateToEffect(e) and tc:IsFaceup() and dc and Duel.SendtoDeck(dc,nil,2,REASON_EFFECT)>0 then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        e1:SetValue(dc:GetBaseAttack())
        tc:RegisterEffect(e1)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_UPDATE_DEFENSE)
        e2:SetValue(dc:GetBaseDefense())
        tc:RegisterEffect(e2)
    end
end
function cm.thfilter(c)
    return c:IsSetCard(0xcc22) and c:IsAbleToDeck()
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsAbleToHand() and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,c) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,1)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,c)
    if not g or g:GetCount()==0 then return end
    local tc=g:GetFirst()
    Duel.ConfirmCards(1-tp,tc)
    if Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)>0 then
        Duel.SendtoHand(c,nil,REASON_EFFECT)
    end
end
