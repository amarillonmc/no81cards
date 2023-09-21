--相剣密使－魚腸
function c49811227.initial_effect(c)
	--set
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,49811227)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
    e1:SetTargetRange(POS_FACEDOWN_DEFENSE,1)
    e1:SetCondition(c49811227.spcon)
    e1:SetOperation(c49811227.spop)
    c:RegisterEffect(e1)
    --sp summon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(49811227,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_BATTLE_DESTROYED)
    e2:SetCountLimit(1,49811228)
    e2:SetCondition(c49811227.gspcon)
    e2:SetTarget(c49811227.gsptg)
    e2:SetOperation(c49811227.gspop)
    c:RegisterEffect(e2)
    --check hand
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(49811227,2))
    e3:SetCategory(CATEGORY_RECOVER)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
    e3:SetCode(EVENT_BE_MATERIAL)
    e3:SetCountLimit(1,49811229)
    e3:SetCondition(c49811227.checon)
    e3:SetTarget(c49811227.chetg)
    e3:SetOperation(c49811227.cheop)
    c:RegisterEffect(e3)
end
function c49811227.spfilter(c,tp)
    return c:IsReleasable() and Duel.GetMZoneCount(1-tp,c,tp)>0
end
function c49811227.spfilter2(c)
    return c:IsType(TYPE_SYNCHRO) and c:IsRace(RACE_WYRM)
end
function c49811227.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.IsExistingMatchingCard(c49811227.spfilter,tp,0,LOCATION_MZONE,1,nil,tp) and Duel.IsExistingMatchingCard(c49811224.spfilter2,tp,LOCATION_MZONE,0,1,nil)
end
function c49811227.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g=Duel.SelectMatchingCard(tp,c49811227.spfilter,tp,0,LOCATION_MZONE,1,1,nil,tp)
    Duel.Release(g,REASON_COST)
end
function c49811227.gspcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsLocation(LOCATION_GRAVE)
end
function c49811227.gsptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c49811227.gspop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
        local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
        if ft>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,20001444,0x16b,TYPES_TOKEN_MONSTER+TYPE_TUNER,0,0,4,RACE_WYRM,ATTRIBUTE_WATER)
            and Duel.SelectYesNo(tp,aux.Stringid(49811227,1)) then
                Duel.BreakEffect()
                local token=Duel.CreateToken(tp,49811228)
                Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
                local e1=Effect.CreateEffect(c)
                e1:SetType(EFFECT_TYPE_FIELD)
                e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
                e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
                e1:SetRange(LOCATION_MZONE)
                e1:SetAbsoluteRange(tp,1,0)
                e1:SetTarget(c49811227.splimit)
                e1:SetReset(RESET_EVENT+RESETS_STANDARD)
                token:RegisterEffect(e1,true)
                Duel.SpecialSummonComplete()
        end
    end
end
function c49811227.splimit(e,c)
    return not c:IsType(TYPE_SYNCHRO) and c:IsLocation(LOCATION_EXTRA)
end
function c49811227.checon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
end
function c49811227.chetg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
end
function c49811227.cheop(e,tp,eg,ep,ev,re,r,rp)
    local hg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
    if hg:GetCount()==0 then return end
    Duel.ConfirmCards(tp,hg)
    Duel.ShuffleHand(1-tp)
end