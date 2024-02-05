--雑食トウテツ
function c49811292.initial_effect(c)
    --control
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(49811292,0))
    e1:SetCategory(CATEGORY_CONTROL)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_HAND)
    e1:SetCost(c49811292.cost)
    e1:SetTarget(c49811292.target)
    e1:SetOperation(c49811292.operation)
    c:RegisterEffect(e1)
end
function c49811292.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c49811292.filter(c)
    return c:IsFaceup() and c:IsRace(RACE_PLANT+RACE_INSECT) and c:IsControlerCanBeChanged()
end
function c49811292.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c49811292.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c49811292.filter,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
    local g=Duel.SelectTarget(tp,c49811292.filter,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c49811292.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRace(RACE_PLANT+RACE_INSECT) then
        Duel.GetControl(tc,tp,PHASE_END,1)
    end
end
