--炎星皇－チョウライオ
function c113705774.initial_effect(c)
    --xyz summon
    aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_FIRE),3,2)
    c:EnableReviveLimit()
    --salvage
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
    e1:SetCondition(c113705774.tdcon1)
    e1:SetCost(c113705774.thcost)
    e1:SetTarget(c113705774.thtg)
    e1:SetOperation(c113705774.thop)
    c:RegisterEffect(e1)
    local e3=e1:Clone()
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetCondition(c113705774.tdcon2)
    c:RegisterEffect(e3)
end
function c113705774.tdcon1(e,tp,eg,ep,ev,re,r,rp)
    return not Duel.IsPlayerAffectedByEffect(tp,11662004)
end
function c113705774.tdcon2(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsPlayerAffectedByEffect(tp,11662004)
end
function c113705774.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c113705774.filter(c)
    return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsAbleToHand()
end
function c113705774.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c113705774.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c113705774.filter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectTarget(tp,c113705774.filter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c113705774.thop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
        e1:SetReset(RESET_PHASE+PHASE_END)
        e1:SetTargetRange(1,0)
        e1:SetTarget(c113705774.sumlimit)
        e1:SetLabel(tc:GetCode())
        Duel.RegisterEffect(e1,tp)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_CANNOT_SUMMON)
        Duel.RegisterEffect(e2,tp)
    end
end
function c113705774.sumlimit(e,c)
    return c:IsCode(e:GetLabel())
end
