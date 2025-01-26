--角獣の制御
function c49811302.initial_effect(c)
    --activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,49811302)
    e1:SetTarget(c49811302.target)
    e1:SetOperation(c49811302.activate)
    c:RegisterEffect(e1)
    --add or special summon
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_REMOVE)
    e2:SetCountLimit(1,49811303)
    e2:SetCondition(c49811302.spcon)
    e2:SetTarget(c49811302.sptg)
    e2:SetOperation(c49811302.spop)
    c:RegisterEffect(e2)
end
function c49811302.filter(c,e,tp)
    return c:IsRace(RACE_BEAST+RACE_WINDBEAST) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsLevelBelow(5) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and not c:IsSummonableCard()
end
function c49811302.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c49811302.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c49811302.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c49811302.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
    end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
    e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
    e1:SetTarget(c49811302.rmtarget)
    e1:SetTargetRange(0xff,0xff)
    e1:SetValue(LOCATION_REMOVED)
    e1:SetReset(RESET_PHASE+PHASE_END,2)
    Duel.RegisterEffect(e1,tp)
end
function c49811302.rmtarget(e,c)
    return c:IsType(TYPE_SPELL)
end
function c49811302.cfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsRace(RACE_BEAST) and c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)
end
function c49811302.spcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c49811302.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c49811302.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then 
    	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsPlayerCanSpecialSummonMonster(tp,49811304,0,TYPES_TOKEN_MONSTER,700,700,1,RACE_BEAST,ATTRIBUTE_LIGHT) 
    end
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c49811302.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    if Duel.IsPlayerCanSpecialSummonMonster(tp,49811304,0,TYPES_TOKEN_MONSTER,700,700,1,RACE_BEAST,ATTRIBUTE_LIGHT) then
        local token=Duel.CreateToken(tp,49811304)
        Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e1:SetRange(LOCATION_MZONE)
        e1:SetAbsoluteRange(tp,1,0)
        e1:SetTarget(c49811302.splimit)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        token:RegisterEffect(e1,true)
        Duel.SpecialSummonComplete()
    end
end
function c49811302.splimit(e,c)
    return not c:IsRace(RACE_BEAST) and c:IsLocation(LOCATION_EXTRA)
end