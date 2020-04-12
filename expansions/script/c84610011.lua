--先史遺産クリスタル・キューブ
function c84610011.initial_effect(c)
    --xyz summon
    aux.AddXyzProcedureLevelFree(c,c84610011.mfilter,c84610011.xyzcheck,2,2)
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_ROCK+RACE_MACHINE),2,2,c84610011.lcheck)
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,84610011)
    e1:SetCondition(c84610011.condition)
    e1:SetTarget(c84610011.sptg)
    e1:SetOperation(c84610011.spop)
    c:RegisterEffect(e1)
    --search
    local e2=e1:Clone()
    e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
    e2:SetCountLimit(1,846100111)
    e2:SetCondition(c84610011.condition2)
    e2:SetTarget(c84610011.thtg2)
    e2:SetOperation(c84610011.thop2)
    c:RegisterEffect(e2)
    --search
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(84610011,0))
    e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetCountLimit(1)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCost(c84610011.cost)
    e3:SetTarget(c84610011.target)
    e3:SetOperation(c84610011.operation)
    c:RegisterEffect(e3)
    --summon
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(84610011,1))
    e4:SetCategory(CATEGORY_SUMMON)
    e4:SetType(EFFECT_TYPE_QUICK_O) 
    e4:SetCode(EVENT_FREE_CHAIN)    
    e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
    e4:SetCountLimit(1)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTargetRange(LOCATION_ONFIELD,0)
    e4:SetCondition(c84610011.sumcon)
    e4:SetTarget(c84610011.target1)
    e4:SetOperation(c84610011.activate1)
    c:RegisterEffect(e4)
    --cannot be battle target
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
    e5:SetRange(LOCATION_MZONE)
    e5:SetTargetRange(0,LOCATION_MZONE)
    e5:SetCondition(c84610011.imcon)
    e5:SetValue(c84610011.tg)
    c:RegisterEffect(e5)
    --negate
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e6:SetCode(EVENT_CHAIN_SOLVING)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCondition(c84610011.necon)
    e6:SetOperation(c84610011.neop)
    c:RegisterEffect(e6)
    --negate
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(84610011,2))
    e7:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e7:SetType(EFFECT_TYPE_QUICK_O)
    e7:SetCode(EVENT_CHAINING)
    e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCondition(c84610011.discon)
    e7:SetCost(c84610011.discost)
    e7:SetTarget(c84610011.distg)
    e7:SetOperation(c84610011.disop)
    c:RegisterEffect(e7)
end
function c84610011.lcheck(g)
    return g:IsExists(Card.IsLinkSetCard,1,nil,0x70)
end
function c84610011.mfilter(c,xyzc)
    return c:IsSetCard(0x70) and not c:IsType(TYPE_XYZ)
end
function c84610011.xyzcheck(g)
    return g:GetClassCount(Card.GetLevel)==1
end
function c84610011.condition(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c84610011.spfilter(c,e,tp)
    return c:IsSetCard(0x70) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and not c:IsCode(84610011)
end
function c84610011.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCountFromEx(tp)>0
        and Duel.IsExistingMatchingCard(c84610011.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c84610011.matfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x70)
end
function c84610011.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCountFromEx(tp)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c84610011.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc then
        ct=Duel.SpecialSummon(g,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
        tc:CompleteProcedure()
    end
    if ct>0 then
        local fg=Duel.GetMatchingGroup(c84610011.matfilter,tp,LOCATION_DECK,0,nil,e,tp,false,false)
        if fg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(84610011,3)) then
            Duel.BreakEffect()
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
            local g=Duel.SelectMatchingCard(tp,c84610011.matfilter,tp,LOCATION_DECK,0,1,1,nil)
            if g:GetCount()>0 then
                Duel.Overlay(tc,g)
            end
        end
    end
end
function c84610011.tfilter(c)
    return c:IsSetCard(0x70) and c:IsAbleToHand()
end
function c84610011.condition2(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c84610011.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c84610011.tfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c84610011.thop2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c84610011.tfilter),tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c84610011.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c84610011.filter(c)
    return (c:IsRace(RACE_MACHINE) or c:IsRace(RACE_ROCK)) and c:IsAbleToHand()
end
function c84610011.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c84610011.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c84610011.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c84610011.filter),tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c84610011.sumfilter(c)
    return c:IsFaceup() and (c:IsRace(RACE_MACHINE) or c:IsRace(RACE_ROCK))
end
function c84610011.sumcon(e)
    return e:GetHandler():GetLinkedGroup():IsExists(c84610011.sumfilter,1,nil)
end
function c84610011.filter1(c)
    return (c:IsRace(RACE_ROCK) or c:IsRace(RACE_MACHINE)) and c:IsSummonable(true,nil)
end
function c84610011.target1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c84610011.filter1,tp,LOCATION_HAND,0,1,nil) 
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
    Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c84610011.activate1(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c84610011.filter1),tp,LOCATION_HAND,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc then
        Duel.Summon(tp,tc,true,nil)
    end
end
function c84610011.nefilter(c)
    return c:IsFaceup() and c:IsSetCard(0x70)
end
function c84610011.imcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetLinkedGroup():IsExists(c84610011.nefilter,1,nil)
end
function c84610011.tg(e,c)
    return c~=e:GetHandler() and c:IsFaceup() and (c:IsRace(RACE_ROCK) or c:IsRace(RACE_MACHINE))
end
function c84610011.necon(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
    return e:GetHandler():GetLinkedGroup():IsExists(c84610011.nefilter,1,nil) and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsAttack(0) and re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c84610011.neop(e,tp,eg,ep,ev,re,r,rp)
    Duel.NegateEffect(ev)
end
function c84610011.discon(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
    return re:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) and Duel.IsChainNegatable(ev)
end
function c84610011.cfilter(c,g)
    return c:IsFaceup() and c:IsSetCard(0x70)
        and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c84610011.discost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroup(tp,c84610011.cfilter,1,nil,lg) end
    local g=Duel.SelectReleaseGroup(tp,c84610011.cfilter,1,1,nil,lg)
    Duel.Release(g,REASON_COST)
end
function c84610011.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end
end
function c84610011.disop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
        Duel.Destroy(eg,REASON_EFFECT)
    end
end
