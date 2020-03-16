--机械崩溃
function c22510013.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOGRAVE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c22510013.target)
    e1:SetOperation(c22510013.activate)
    c:RegisterEffect(e1)
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetCode(EFFECT_TRAP_ACT_IN_HAND)
    e6:SetCondition(c22510013.handcon)
    c:RegisterEffect(e6)
end
function c22510013.lkfilter(c)
    return c:IsSetCard(0xec0) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c22510013.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsDestructable() and chkc:IsControler(1-tp) end
    if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) and Duel.IsExistingMatchingCard(c22510013.lkfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c22510013.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
        local g=Duel.SelectMatchingCard(tp,c22510013.lkfilter,tp,LOCATION_DECK,0,1,1,nil)
        if not g or Duel.SendtoGrave(g,REASON_EFFECT)<1 then return end
        Duel.Destroy(tc,REASON_EFFECT)
    end
end
function c22510013.handcon(e)
    return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_HAND,0)==5
end
