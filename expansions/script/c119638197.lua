--魁炎星王－ソウコ
function c119638197.initial_effect(c)
    --xyz summon
    aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_BEASTWARRIOR),4,2)
    c:EnableReviveLimit()
    --set
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(119638197,0))
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCondition(c119638197.setcon)
    e1:SetTarget(c119638197.settg)
    e1:SetOperation(c119638197.setop)
    c:RegisterEffect(e1)
    --negate
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(119638197,1))
    e2:SetCategory(CATEGORY_DISABLE)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
    e2:SetCondition(c119638197.tdcon1)
    e2:SetCost(c119638197.discost)
    e2:SetTarget(c119638197.distg)
    e2:SetOperation(c119638197.disop)
    c:RegisterEffect(e2)
    local e4=e2:Clone()
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetCondition(c119638197.tdcon2)
    c:RegisterEffect(e4)
    --spsummon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(119638197,2))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetCondition(c119638197.spcon)
    e3:SetCost(c119638197.spcost)
    e3:SetTarget(c119638197.sptg)
    e3:SetOperation(c119638197.spop)
    c:RegisterEffect(e3)
end
function c119638197.setcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c119638197.filter(c)
    return c:IsSetCard(0x7c) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c119638197.settg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c119638197.filter,tp,LOCATION_DECK,0,1,nil) end
end
function c119638197.setop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
    local g=Duel.SelectMatchingCard(tp,c119638197.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SSet(tp,g:GetFirst())
    end
end
function c119638197.tdcon1(e,tp,eg,ep,ev,re,r,rp)
    return not Duel.IsPlayerAffectedByEffect(tp,11662004)
end
function c119638197.tdcon2(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsPlayerAffectedByEffect(tp,11662004)
end
function c119638197.discost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c119638197.dfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_EFFECT) and not c:IsRace(RACE_BEASTWARRIOR)
end
function c119638197.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c119638197.dfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function c119638197.disop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c119638197.dfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    local tc=g:GetFirst()
    local c=e:GetHandler()
    while tc do
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
        tc:RegisterEffect(e2)
        tc=g:GetNext()
    end
end
function c119638197.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c119638197.cfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x7c) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGraveAsCost()
end
function c119638197.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c119638197.cfilter,tp,LOCATION_ONFIELD,0,3,nil)
        or Duel.IsPlayerAffectedByEffect(tp,46241344) end
    if Duel.IsExistingMatchingCard(c119638197.cfilter,tp,LOCATION_ONFIELD,0,3,nil)
        and (not Duel.IsPlayerAffectedByEffect(tp,46241344) or not Duel.SelectYesNo(tp,aux.Stringid(46241344,0))) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
        local g=Duel.SelectMatchingCard(tp,c119638197.cfilter,tp,LOCATION_ONFIELD,0,3,3,nil)
        Duel.SendtoGrave(g,REASON_COST)
    end
end
function c119638197.spfilter(c,e,tp)
    return c:IsLevelBelow(4) and c:IsRace(RACE_BEASTWARRIOR) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c119638197.afilter1(c,g)
    return g:IsExists(c119638197.afilter2,1,c,c:GetAttack())
end
function c119638197.afilter2(c,atk)
    return c:IsAttack(atk)
end
function c119638197.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local g=Duel.GetMatchingGroup(c119638197.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
        return not Duel.IsPlayerAffectedByEffect(tp,59822133)
            and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and g:IsExists(c119638197.afilter1,1,nil,g)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function c119638197.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
    local g=Duel.GetMatchingGroup(c119638197.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
    local dg=g:Filter(c119638197.afilter1,nil,g)
    if dg:GetCount()>=1 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local tc1=dg:Select(tp,1,1,nil):GetFirst()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local tc2=dg:FilterSelect(tp,c119638197.afilter2,1,1,tc1,tc1:GetAttack()):GetFirst()
        Duel.SpecialSummonStep(tc1,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
        Duel.SpecialSummonStep(tc2,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
        Duel.SpecialSummonComplete()
    end
end
