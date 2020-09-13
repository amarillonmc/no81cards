function c89380006.initial_effect(c)
    c:SetUniqueOnField(1,1,89380006)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetRange(LOCATION_HAND)
    e1:SetCost(c89380006.spcost)
    e1:SetTarget(c89380006.target)
    e1:SetOperation(c89380006.operation)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_SZONE)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCondition(c89380006.drcon)
    e2:SetCost(c89380006.drcost)
    e2:SetTarget(c89380006.drtarget)
    e2:SetOperation(c89380006.drop)
    c:RegisterEffect(e2)
end
function c89380006.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsDiscardable() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c89380006.spfilter(c)
    return c:IsSetCard(0xcc00) and not c:IsCode(89380006) and c:IsAbleToHand()
end
function c89380006.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c89380006.spfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c89380006.spfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectTarget(tp,c89380006.spfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c89380006.eqfilter(c)
    return c:IsCode(89380009) and c:IsFaceup()
end
function c89380006.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
    end
    local c=e:GetHandler()
    if Duel.IsExistingMatchingCard(c89380006.eqfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and c:IsLocation(LOCATION_GRAVE) and c:CheckUniqueOnField(tp) and not c:IsForbidden() and Duel.SelectYesNo(tp,aux.Stringid(89380006,0)) then
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
        local g=Duel.SelectMatchingCard(tp,c89380006.eqfilter,tp,LOCATION_MZONE,0,1,1,nil)
        if not (g and Duel.Equip(tp,c,g:GetFirst(),false)) then return end
        local e1=Effect.CreateEffect(g:GetFirst())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
        e1:SetCode(EFFECT_EQUIP_LIMIT)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        e1:SetValue(c89380006.eqlimit)
        c:RegisterEffect(e1)
    end
end
function c89380006.eqlimit(e,c)
    return e:GetOwner()==c
end
function c89380006.drcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsType(TYPE_EQUIP)
end
function c89380006.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c89380006.drfilter(c,tp)
    return c:IsSetCard(0xcc00) and not c:IsCode(89380006) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function c89380006.drtarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c89380006.drfilter(chkc,tp) end
    if chk==0 then return Duel.IsExistingTarget(c89380006.drfilter,tp,LOCATION_GRAVE,0,1,nil,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    local g=Duel.SelectTarget(tp,c89380006.drfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
    Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,0)
end
function c89380006.drop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.IsExistingMatchingCard(c89380006.eqfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
        local g=Duel.SelectMatchingCard(tp,c89380006.eqfilter,tp,LOCATION_MZONE,0,1,1,nil)
        if not (g and Duel.Equip(tp,tc,g:GetFirst(),false)) then return end
        local e1=Effect.CreateEffect(g:GetFirst())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
        e1:SetCode(EFFECT_EQUIP_LIMIT)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        e1:SetValue(c89380006.eqlimit)
        tc:RegisterEffect(e1)
    end
end