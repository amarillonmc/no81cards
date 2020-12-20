--フレッシュマドルチェ・アソーティ
function c84610010.initial_effect(c)
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x71),2,2)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_QUICK_O) 
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetCode(EVENT_FREE_CHAIN)    
    e1:SetRange(LOCATION_EXTRA)
    e1:SetCountLimit(1,84610010)
    e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
    e1:SetCost(c84610010.spcost)
    e1:SetTarget(c84610010.sptg)
    e1:SetOperation(c84610010.spop)
    c:RegisterEffect(e1)
    --tohand
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetCondition(c84610010.thcon)
    e2:SetTarget(c84610010.thtg)
    e2:SetOperation(c84610010.thop)
    c:RegisterEffect(e2)
    --indes
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(LOCATION_ONFIELD,0)
    e1:SetCondition(c84610010.indescon)
    e1:SetTarget(c84610010.indestg)
    e1:SetValue(1)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e2:SetValue(aux.tgoval)
    c:RegisterEffect(e2)
    --activate from hand
    local e3=e1:Clone()
    e3:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
    e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x71))
    e3:SetTargetRange(LOCATION_HAND,0)
    c:RegisterEffect(e3)
    local e4=e1:Clone()
    e4:SetCode(EFFECT_TRAP_ACT_IN_HAND)
    e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x71))
    e4:SetTargetRange(LOCATION_HAND,0)
    c:RegisterEffect(e4)
    --immune
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(c84610010.imcon)
    e1:SetOperation(c84610010.imop)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    c:RegisterEffect(e2)
end
function c84610010.spcfilter(c)
    return c:IsSetCard(0x71) and c:IsAbleToDeckAsCost()
end
function c84610010.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local rg=Duel.GetMatchingGroup(c84610010.spcfilter,tp,LOCATION_HAND,0,e:GetHandler())
    if chk==0 then return rg:GetClassCount(Card.GetCode)>=4 end
    local g=Group.CreateGroup()
    for i=1,4 do
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
        local tc=rg:Select(tp,1,1,nil):GetFirst()
        rg:Remove(Card.IsCode,nil,tc:GetCode())
        g:AddCard(tc)
    end
    Duel.ConfirmCards(1-tp,g)
    Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c84610010.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCountFromEx(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,LOCATION_EXTRA)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c84610010.spfilter(c,e,tp)
    return c:IsSetCard(0x71) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function c84610010.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if c then
        ct=Duel.SpecialSummon(c,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)
        c:CompleteProcedure()
    end
    if ct>0 then
        local fg=Duel.GetMatchingGroup(c84610010.spfilter,tp,LOCATION_DECK,0,nil,e,tp,false,false)
        if fg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(84610010,0)) then
            Duel.BreakEffect()
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
            local sg=fg:Select(tp,1,1,nil)
            Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
        end
    end
end
function c84610010.thcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c84610010.thfilter(c)
    return c:IsSetCard(0x71) and c:IsAbleToHand()
end
function c84610010.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c84610010.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c84610010.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c84610010.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c84610010.indesfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x71)
end
function c84610010.indescon(e)
    return e:GetHandler():GetLinkedGroup():IsExists(c84610010.indesfilter,1,nil)
end
function c84610010.indestg(e,c)
    return c:IsSetCard(0x71) and c:IsType(TYPE_MONSTER)
end
function c84610010.cfilter(c,ec)
    if c:IsLocation(LOCATION_MZONE) then
        return c:IsSetCard(0x71) and c:IsFaceup() and ec:GetLinkedGroup():IsContains(c)
    else
        return c:IsPreviousSetCard(0x71) and c:IsPreviousPosition(POS_FACEUP)
            and bit.extract(ec:GetLinkedZone(c:GetPreviousControler()),c:GetPreviousSequence())~=0
    end
end
function c84610010.imcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c84610010.cfilter,1,nil,e:GetHandler())
end
function c84610010.imop(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetTargetRange(LOCATION_ONFIELD,0)
    e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x71))
    e1:SetValue(c84610010.ifilter)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function c84610010.ifilter(e,re)
    return re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
