--粘糸壊獣クモグス
function c84610033.initial_effect(c)
    c:SetUniqueOnField(1,0,c84610033.uqfilter,LOCATION_MZONE)
    --special summon rule
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetRange(LOCATION_HAND)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
    e1:SetTargetRange(POS_FACEUP_ATTACK,1)
    e1:SetCondition(c84610033.spcon)
    e1:SetOperation(c84610033.spop)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetRange(LOCATION_HAND)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
    e2:SetTargetRange(POS_FACEUP_ATTACK,0)
    e2:SetCondition(c84610033.spcon2)
    c:RegisterEffect(e2)
    --disable
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_DISABLE)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_SUMMON_SUCCESS)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCost(c84610033.cost)
    e3:SetTarget(c84610033.target)
    e3:SetOperation(c84610033.operation)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e4)
end
function c84610033.unlimfilter(c,tp)
    return c:IsCode(84610023) and c:IsFaceup()
end
function c84610033.uqfilter(c)
    if Duel.IsExistingMatchingCard(c84610033.unlimfilter,tp,LOCATION_MZONE+LOCATION_PZONE,LOCATION_MZONE+LOCATION_PZONE,1,nil,tp) then
        return c:IsCode(84610033)
    else
        return c:IsSetCard(0xd3)
    end
end
function c84610033.spfilter(c,tp)
    return c:IsReleasable() and Duel.GetMZoneCount(1-tp,c,tp)>0
end
function c84610033.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.IsExistingMatchingCard(c84610033.spfilter,tp,0,LOCATION_MZONE,1,nil,tp)
end
function c84610033.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g=Duel.SelectMatchingCard(tp,c84610033.spfilter,tp,0,LOCATION_MZONE,1,1,nil,tp)
    Duel.Release(g,REASON_COST)
end
function c84610033.cfilter(c)
    return c:IsFaceup() and c:IsSetCard(0xd3)
end
function c84610033.spcon2(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c84610033.cfilter,tp,0,LOCATION_MZONE,1,nil)
end
function c84610033.filter(c,tp)
    return c:GetSummonPlayer()==tp and c:IsFaceup()
end
function c84610033.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x37,2,REASON_COST) end
    Duel.RemoveCounter(tp,1,1,0x37,2,REASON_COST)
end
function c84610033.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return eg:IsExists(c84610033.filter,1,nil,1-tp) and not eg:IsContains(e:GetHandler()) end
    local g=eg:Filter(c84610033.filter,nil,1-tp)
    Duel.SetTargetCard(g)
end
function c84610033.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    local tc=g:GetFirst()
    while tc do
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CANNOT_ATTACK)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
        tc:RegisterEffect(e2)
        local e3=Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_DISABLE_EFFECT)
        e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
        tc:RegisterEffect(e3)
        tc=g:GetNext()
    end
end
