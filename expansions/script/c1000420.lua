--四次元爆弹
function c1000420.initial_effect(c)
    --destroy
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCountLimit(1,10004201)
    e1:SetCondition(c1000420.condition)
    e1:SetTarget(c1000420.target)
    e1:SetOperation(c1000420.activate)
    c:RegisterEffect(e1)
    --destroy1
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCountLimit(1,10004202)
    e2:SetCondition(c1000420.condition)
    e2:SetCost(c1000420.thcost)
    e2:SetTarget(c1000420.target)
    e2:SetOperation(c1000420.activate)
    c:RegisterEffect(e2)
    --destroy2
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_REMOVED)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetCountLimit(1,10004203)
    e3:SetCondition(c1000420.condition)
    e3:SetCost(c1000420.thcost)
    e3:SetTarget(c1000420.target)
    e3:SetOperation(c1000420.activate)
    c:RegisterEffect(e3)
    --destroy3
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_DESTROY)
    e4:SetType(EFFECT_TYPE_ACTIVATE)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e4:SetCountLimit(1,10004204)
    e4:SetCondition(c1000420.gcondition)
    e4:SetCost(c1000420.hhcost)
    e4:SetTarget(c1000420.target)
    e4:SetOperation(c1000420.activate)
    c:RegisterEffect(e4)
end
function c1000420.cfilter(c)
    return c:IsFaceup() and c:IsCode(1000406) and c:IsType(TYPE_MONSTER)
end
function c1000420.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c1000420.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c1000420.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and chkc:IsDestructable() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c1000420.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.Destroy(tc,REASON_EFFECT)
    end
end
function c1000420.cfilter1(c)
    return c:IsSetCard(0xa201) and c:IsAbleToRemoveAsCost()
end
function c1000420.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToHandAsCost()
        and Duel.IsExistingMatchingCard(c1000420.cfilter1,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c1000420.cfilter1,tp,LOCATION_GRAVE,0,1,1,nil)
    g:AddCard(e:GetHandler())
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c1000420.gcondition(e,tp,eg,ep,ev,re,r,rp)
    return not Duel.IsExistingMatchingCard(c1000420.cfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
end
function c1000420.gfilter(c)
    return c:IsCode(1000406) and c:IsAbleToDeckAsCost()
end
function c1000420.hhcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c1000420.gfilter,tp,LOCATION_HAND,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c1000420.gfilter,tp,LOCATION_HAND,0,1,1,nil)
    Duel.SendtoDeck(g,nil,2,REASON_COST)
end
