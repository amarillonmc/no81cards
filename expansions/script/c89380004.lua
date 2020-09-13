function c89380004.initial_effect(c)
    c:SetUniqueOnField(1,1,89380004)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c89380004.spcon)
    e1:SetCost(c89380004.spcost)
    e1:SetOperation(c89380004.operation)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_EQUIP)
    e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
    e2:SetValue(c89380004.valcon)
    e2:SetCountLimit(1)
    c:RegisterEffect(e2)
    local e3=e1:Clone()
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetCondition(c89380004.spcono)
    c:RegisterEffect(e3)
end
function c89380004.spcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,89380009)
end
function c89380004.spcono(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_MZONE,0,nil,89380009)==0 
end
function c89380004.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsDiscardable() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c89380004.eqfilter(c)
    return c:IsCode(89380009) and c:IsFaceup()
end
function c89380004.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CHANGE_DAMAGE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,0)
    e1:SetValue(c89380004.damval)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
    Duel.RegisterFlagEffect(tp,89380004,RESET_PHASE+PHASE_END,0,1)
    if Duel.IsExistingMatchingCard(c89380004.eqfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and c:IsLocation(LOCATION_GRAVE) and c:CheckUniqueOnField(tp) and not c:IsForbidden() and Duel.SelectYesNo(tp,aux.Stringid(89380004,0)) then
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
        local g=Duel.SelectMatchingCard(tp,c89380004.eqfilter,tp,LOCATION_MZONE,0,1,1,nil)
        if not (g and Duel.Equip(tp,c,g:GetFirst(),false)) then return end
        local e1=Effect.CreateEffect(g:GetFirst())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
        e1:SetCode(EFFECT_EQUIP_LIMIT)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        e1:SetValue(c89380004.eqlimit)
        c:RegisterEffect(e1)
    end
end
function c89380004.damval(e,re,val,r,rp,rc)
    local tp=e:GetHandlerPlayer()
    if Duel.GetFlagEffect(tp,89380004)==0 or bit.band(r,REASON_EFFECT+REASON_BATTLE)==0 then return val end
    Duel.ResetFlagEffect(tp,89380004)
    return 0
end
function c89380004.eqlimit(e,c)
    return e:GetOwner()==c
end
function c89380004.valcon(e,re,r,rp)
    return r==REASON_BATTLE
end