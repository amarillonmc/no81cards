--しばしば接触するＧ
function c49811162.initial_effect(c)
    --change name
    aux.EnableChangeCode(c,87170768,LOCATION_GRAVE)
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(49811162,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,49811162)
    e1:SetCondition(c49811162.spcon)
    e1:SetTarget(c49811162.sptg)
    e1:SetOperation(c49811162.spop)
    c:RegisterEffect(e1)
    if not c49811162.global_check then
        c49811162.global_check=true
        local ge1=Effect.CreateEffect(c)
        ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
        ge1:SetOperation(c49811162.checkop)
        Duel.RegisterEffect(ge1,0)
    end
    --controller
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(49811162,1))
    e2:SetCategory(CATEGORY_CONTROL)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCondition(c49811162.concon)
    e2:SetTarget(c49811162.contg)
    e2:SetOperation(c49811162.conop)
    c:RegisterEffect(e2)
end
function c49811162.spcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFlagEffect(1-tp,49811162)>=5 and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c49811162.checkop(e,tp,eg,ep,ev,re,r,rp)
    local tc=eg:GetFirst()
    while tc do
        Duel.RegisterFlagEffect(tc:GetSummonPlayer(),49811162,RESET_PHASE+PHASE_END,0,1)
        tc=eg:GetNext()
    end
end
function c49811162.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c49811162.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if Duel.SpecialSummonStep(c,0,tp,1-tp,false,false,POS_FACEUP_ATTACK) then
        c:RegisterFlagEffect(49811162,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1)
    end
    Duel.SpecialSummonComplete()
end
function c49811162.filter(c)
    return c:IsControlerCanBeChanged()
end
function c49811162.concon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL and e:GetHandler():GetFlagEffect(49811162)>0
end
function c49811162.contg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c49811162.filter,tp,LOCATION_MZONE,0,1,e:GetHandler())
        and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
    end
    Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,0,LOCATION_MZONE)
end
function c49811162.conop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
    local g=Duel.SelectMatchingCard(tp,c49811162.filter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
    if g:GetCount()>0 then
        Duel.GetControl(g,1-tp)
    end
end