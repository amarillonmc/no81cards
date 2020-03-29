function c117981478.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetRange(LOCATION_HAND)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,117981478)
    e1:SetCost(c117981478.spcost)
    e1:SetTarget(c117981478.target)
    e1:SetOperation(c117981478.operation)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetTargetRange(LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE,0)
    e2:SetCode(EFFECT_CHANGE_RACE)
    e2:SetValue(RACE_DRAGON)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e3:SetCode(EVENT_BE_MATERIAL)
    e3:SetCondition(c117981478.bftg)
    e3:SetOperation(c117981478.bfop)
    c:RegisterEffect(e3)
end
function c117981478.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
    Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,e:GetHandler())
end
function c117981478.spfilter(c,e,tp)
    return c:IsSetCard(0xdd) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c117981478.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
        and Duel.IsExistingMatchingCard(c117981478.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND+LOCATION_DECK)
end
function c117981478.operation(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 or not e:GetHandler():IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c117981478.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    if g:GetCount()==0 then return end
    local tc=g:GetFirst()
    local c=e:GetHandler()
    local fid=c:GetFieldID()
    Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
    Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP)
    Duel.SpecialSummonComplete()
    g:AddCard(c)
    local sg=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,nil,g)
    if sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(117981478,0)) then
        if not sg then return end
        local sc=sg:Select(tp,1,1,nil):GetFirst()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        Duel.SynchroSummon(tp,sc,nil,g)
    end
end
function c117981478.bftg(e,tp,eg,ep,ev,re,r,rp)
    return r==REASON_SYNCHRO
end
function c117981478.bfop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local rc=c:GetReasonCard()
    if rc:GetFlagEffect(117981478)==0 then
        local e1=Effect.CreateEffect(c)
        e1:SetDescription(aux.Stringid(117981478,1))
        e1:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_PLAYER_TARGET)
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e1:SetRange(LOCATION_MZONE)
        e1:SetCondition(c117981478.discon)
        e1:SetOperation(c117981478.disop)
        e1:SetCode(EVENT_CHAIN_SOLVING)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        e1:SetAbsoluteRange(ep,0,1)
        rc:RegisterEffect(e1,tp)
        rc:RegisterFlagEffect(117981478,RESET_EVENT+0x1fe0000,0,1)
    end
end
function c117981478.discon(e,tp,eg,ep,ev,re,r,rp)
    return re:IsActiveType(TYPE_MONSTER) and rp==1-tp and re:GetHandler():IsAttackBelow(2500)
end
function c117981478.disop(e,tp,eg,ep,ev,re,r,rp)
    Duel.NegateEffect(ev)
end