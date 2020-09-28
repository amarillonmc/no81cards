--机皇神兽 轮换异虫
local m=89387019
local cm=_G["c"..m]
function cm.initial_effect(c)
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_MACHINE),2,3)
    c:EnableReviveLimit()
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_IMMUNE_EFFECT)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(LOCATION_MZONE,0)
    e3:SetValue(cm.imvalue)
    c:RegisterEffect(e3)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_ADD_TYPE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(0,LOCATION_MZONE)
    e1:SetValue(TYPE_SYNCHRO)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetValue(cm.atkval)
    c:RegisterEffect(e2)
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_DESTROY+CATEGORY_RECOVER)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1)
    e4:SetTarget(cm.sptg2)
    e4:SetOperation(cm.spop2)
    c:RegisterEffect(e4)
end
function cm.imvalue(e,re)
    return re:GetOwner():IsSetCard(0x3013)
end
function cm.cfilter(c)
    return c:IsType(TYPE_SYNCHRO+TYPE_EQUIP)
end
function cm.atkval(e,c)
    return Duel.GetMatchingGroup(cm.cfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil):GetSum(Card.GetBaseAttack)
end
function cm.spfilter(c)
    return c:IsSetCard(0x3013) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() and chkc~=e:GetHandler() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,e:GetHandler()) and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,1,tp,g:GetFirst():GetBaseAttack())
end
function cm.spop2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsFaceup() then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil)
        if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
            Duel.ConfirmCards(1-tp,g)
            Duel.BreakEffect()
            Duel.Destroy(tc,REASON_EFFECT)
            Duel.Recover(tp,tc:GetBaseAttack(),REASON_EFFECT)
        end
    end
end
