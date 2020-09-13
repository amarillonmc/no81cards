function c89380003.initial_effect(c)
    c:SetUniqueOnField(1,1,89380003)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c89380003.spcon)
    e1:SetCost(c89380003.spcost)
    e1:SetTarget(c89380003.target)
    e1:SetOperation(c89380003.operation)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCondition(c89380003.drcon)
    e2:SetCost(c89380003.drcost)
    e2:SetOperation(c89380003.drop)
    c:RegisterEffect(e2)
    local e3=e1:Clone()
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetCondition(c89380003.spcono)
    c:RegisterEffect(e3)
end
function c89380003.spcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,89380009)
end
function c89380003.spcono(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_MZONE,0,nil,89380009)==0 
end
function c89380003.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsDiscardable() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c89380003.tfilter(c)
    return c:IsFaceup() and not c:IsCode(89380003) and c:IsAbleToHand()
end
function c89380003.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c89380003.tfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_SZONE)
end
function c89380003.eqfilter(c)
    return c:IsCode(89380009) and c:IsFaceup()
end
function c89380003.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tg=Duel.GetMatchingGroup(c89380003.tfilter,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
    if not tg then return end
    Duel.SendtoHand(tg,nil,REASON_EFFECT)
    if Duel.IsExistingMatchingCard(c89380003.eqfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and c:IsLocation(LOCATION_GRAVE) and c:CheckUniqueOnField(tp) and not c:IsForbidden() and Duel.SelectYesNo(tp,aux.Stringid(89380003,0)) then
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
        local g=Duel.SelectMatchingCard(tp,c89380003.eqfilter,tp,LOCATION_MZONE,0,1,1,nil)
        if not (g and Duel.Equip(tp,c,g:GetFirst(),false)) then return end
        local e1=Effect.CreateEffect(g:GetFirst())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
        e1:SetCode(EFFECT_EQUIP_LIMIT)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        e1:SetValue(c89380003.eqlimit)
        c:RegisterEffect(e1)
    end
end
function c89380003.eqlimit(e,c)
    return e:GetOwner()==c
end
function c89380003.drcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsType(TYPE_EQUIP)
end
function c89380003.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
    Duel.SetTargetCard(e:GetHandler():GetEquipTarget())
    Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c89380003.drop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsFaceup() and tc:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_ATTACK_ALL)
        e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        e1:SetValue(1)
        tc:RegisterEffect(e1)
    end
end