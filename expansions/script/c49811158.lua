--ぐずぐず増殖するG
function c49811158.initial_effect(c)
    --change name
    aux.EnableChangeCode(c,23434538,LOCATION_GRAVE)
    --draw
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(49811158,0))
    e1:SetCategory(CATEGORY_DRAW)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,49811158)
    e1:SetCost(c49811158.cost)
    e1:SetOperation(c49811158.operation)
    c:RegisterEffect(e1)    
    --
    if not c49811158.globle_check then
        c49811158.globle_check=true
        --summon check
        local ge1=Effect.CreateEffect(c)
        ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        ge1:SetCode(EVENT_SUMMON_SUCCESS)
        ge1:SetOperation(c49811158.checkop)
        Duel.RegisterEffect(ge1,0)
        local ge2=ge1:Clone()
        ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
        Duel.RegisterEffect(ge2,0)
    end
end
function c49811158.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
    Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c49811158.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_PHASE+PHASE_END)
    e2:SetCountLimit(1)
    e2:SetCondition(c49811158.effcon)
    e2:SetOperation(c49811158.effop)
    e2:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e2,tp)
end
function c49811158.checkop(e,tp,eg,ep,ev,re,r,rp)
    local tc=eg:GetFirst()
    while tc do
        Duel.RegisterFlagEffect(tc:GetSummonPlayer(),49811158,RESET_PHASE+PHASE_END,0,1)
        tc=eg:GetNext()
    end
end
function c49811158.effcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFlagEffect(1-tp,49811158)>=3
end
function c49811158.effop(e,tp,eg,ep,ev,re,r,rp)
    local ct=Duel.GetFlagEffect(1-tp,49811158)
    local cd=math.floor(ct/3)
    Duel.Draw(tp,cd,REASON_EFFECT)
end