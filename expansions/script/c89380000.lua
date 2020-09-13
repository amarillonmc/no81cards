function c89380000.initial_effect(c)
    c:SetUniqueOnField(1,1,89380000)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c89380000.spcon)
    e1:SetCost(c89380000.spcost)
    e1:SetTarget(c89380000.target)
    e1:SetOperation(c89380000.operation)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCondition(c89380000.drcon)
    e2:SetCost(c89380000.drcost)
    e2:SetTarget(c89380000.drtarget)
    e2:SetOperation(c89380000.drop)
    c:RegisterEffect(e2)
    local e3=e1:Clone()
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetCondition(c89380000.spcono)
    c:RegisterEffect(e3)
end
function c89380000.spcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,89380009)
end
function c89380000.spcono(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_MZONE,0,nil,89380009)==0 
end

function c89380000.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsDiscardable() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c89380000.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_MZONE)
end
function c89380000.eqfilter(c)
    return c:IsCode(89380009) and c:IsFaceup()
end
function c89380000.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
    local tg=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    if not tg then return end
    Duel.SendtoHand(tg,nil,REASON_EFFECT)
    if Duel.IsExistingMatchingCard(c89380000.eqfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and c:IsLocation(LOCATION_GRAVE) and c:CheckUniqueOnField(tp) and not c:IsForbidden() and Duel.SelectYesNo(tp,aux.Stringid(89380000,0)) then
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
        local g=Duel.SelectMatchingCard(tp,c89380000.eqfilter,tp,LOCATION_MZONE,0,1,1,nil)
        if not (g and Duel.Equip(tp,c,g:GetFirst(),false)) then return end
        local e1=Effect.CreateEffect(g:GetFirst())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
        e1:SetCode(EFFECT_EQUIP_LIMIT)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        e1:SetValue(c89380000.eqlimit)
        c:RegisterEffect(e1)
    end
end
function c89380000.eqlimit(e,c)
    return e:GetOwner()==c
end
function c89380000.drcon(e,tp,eg,ep,ev,re,r,rp)
    local a=Duel.GetAttacker()
    local d=Duel.GetAttackTarget()
    if a and not a:IsRelateToBattle() or d and not d:IsRelateToBattle() then return end
    local tc
    if a and a:GetControler()==tp then
        tc=a
    elseif d and d:GetControler()==tp then
        tc=d
    end
    return tc and e:GetHandler():GetEquipTarget()==tc
end
function c89380000.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c89380000.drtarget(e,tp,eg,ep,ev,re,r,rp,chk)
    local a=Duel.GetAttacker()
    local d=Duel.GetAttackTarget()
    if a and not a:IsRelateToBattle() or d and not d:IsRelateToBattle() then return end
    local tc
    if a and a:GetControler()==tp then
        tc=d
    elseif d and d:GetControler()==tp then
        tc=a
    end
    if chk==0 then return tc and tc:IsAbleToHand() end
end
function c89380000.drop(e,tp,eg,ep,ev,re,r,rp)
    local a=Duel.GetAttacker()
    local d=Duel.GetAttackTarget()
    if a and not a:IsRelateToBattle() or d and not d:IsRelateToBattle() then return end
    local tc
    if a and a:GetControler()==tp then
        tc=d
    elseif d and d:GetControler()==tp then
        tc=a
    end
    Duel.SendtoHand(tc,nil,REASON_EFFECT)
end