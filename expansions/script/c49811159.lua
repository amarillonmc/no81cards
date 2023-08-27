--ふわふわ飛翔するG
function c49811159.initial_effect(c)
    --code
    aux.EnableChangeCode(c,80978111,LOCATION_GRAVE)
    --set
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(49811159,0))
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c49811159.setcon)
    e1:SetTarget(c49811159.settg)
    e1:SetOperation(c49811159.setop)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2)
    --check
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(63737050,0))
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCondition(c49811159.condition)
    e3:SetOperation(c49811159.operation)
    c:RegisterEffect(e3)
    --sum limit
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetRange(LOCATION_SZONE)
    e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e4:SetTargetRange(1,0)
    e4:SetCondition(c49811159.slcon1)
    e4:SetTarget(c49811159.splimit)
    c:RegisterEffect(e4)
    local e5=e4:Clone()
    e5:SetTargetRange(0,1)
    e5:SetCondition(c49811159.slcon2)
    c:RegisterEffect(e5)
end
function c49811159.cfilter(c,tp)
    return c:IsSummonPlayer(tp)
end
function c49811159.setcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c49811159.cfilter,1,nil,1-tp)
end
function c49811159.settg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 end
    Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c49811159.setop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if Duel.MoveToField(c,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true) then
        local e1=Effect.CreateEffect(c)
        e1:SetCode(EFFECT_CHANGE_TYPE)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
        e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
        c:RegisterEffect(e1)
    end
end
function c49811159.splimit(e,c,tp,sumtp,sumpos)
    return not c:IsSummonableCard()
end
function c49811159.slcon1(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetFlagEffect(49811159)>0
end
function c49811159.slcon2(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetFlagEffect(49811160)>0
end
function c49811159.cfilter1(c)
    return not c:IsSummonableCard()
end
function c49811159.condition(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c49811159.cfilter1,1,nil)
end
function c49811159.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    for tc in aux.Next(eg) do
        if tc:IsSummonPlayer(1-tp) then
            c:RegisterFlagEffect(49811160,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(49811159,4))
        else 
            c:RegisterFlagEffect(49811159,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(49811159,3))
        end
    end
end