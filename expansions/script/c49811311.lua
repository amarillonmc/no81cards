--惑星の訪問者
function c49811311.initial_effect(c)
    --link summon
    local e0=aux.AddLinkProcedure(c,c49811311.matfilter,1,1)
    e0:SetProperty(e0:GetProperty()|EFFECT_FLAG_SET_AVAILABLE)
    c:EnableReviveLimit()
    --search
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(49811311,0))
    e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_TOGRAVE)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_MZONE)
    e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
    e1:SetCountLimit(1,49811311)
    e1:SetCost(c49811311.cost)
    e1:SetTarget(c49811311.tg)
    e1:SetOperation(c49811311.op)
    c:RegisterEffect(e1)
    --spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(49811311,3))
    e2:SetCategory(CATEGORY_SPSUMMON)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_LEAVE_FIELD)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCondition(c49811311.spcon)
    e2:SetTarget(c49811311.sptg)
    e2:SetOperation(c49811311.spop)
    c:RegisterEffect(e2)
end    
function c49811311.matfilter(c)
    return c:IsLinkSetCard(0x3e)
end
function c49811311.costfilter(c,tp)
    return c:IsRace(RACE_REPTILE) and c:IsControler(tp) and c:IsReleasable()
end
function c49811311.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c49811311.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g=Duel.SelectMatchingCard(tp,c49811311.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil,tp)
    Duel.Release(g,REASON_COST)
end
function c49811311.thfilter(c)
    return c:IsCode(49811312) and c:IsAbleToHand()
end
function c49811311.tgfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x3e) and c:IsAbleToGrave()
end
function c49811311.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local b1=Duel.IsExistingMatchingCard(c49811311.thfilter,tp,LOCATION_DECK,0,1,nil)
    local b2=Duel.IsExistingMatchingCard(c49811311.tgfilter,tp,LOCATION_DECK,0,1,nil)
    if chk==0 then return b1 or b2 end
end
function c49811311.op(e,tp,eg,ep,ev,re,r,rp)
    local b1=Duel.IsExistingMatchingCard(c49811311.thfilter,tp,LOCATION_DECK,0,1,nil)
    local b2=Duel.IsExistingMatchingCard(c49811311.tgfilter,tp,LOCATION_DECK,0,1,nil)
    local off=1
    local ops,opval={},{}
    if b1 then
        ops[off]=aux.Stringid(49811311,1)
        opval[off]=0
        off=off+1
    end
    if b2 then
        ops[off]=aux.Stringid(49811311,2)
        opval[off]=1
        off=off+1
    end
    local op=Duel.SelectOption(tp,table.unpack(ops))+1
    local sel=opval[op]
    local resolve=false
    if sel==0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local g=Duel.SelectMatchingCard(tp,c49811311.thfilter,tp,LOCATION_DECK,0,1,1,nil)
        if g:GetCount()>0 then
            Duel.SendtoHand(g,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,g)
        end
    else
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
        local g=Duel.SelectMatchingCard(tp,c49811311.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
        if g:GetCount()>0 then
            Duel.SendtoGrave(g,REASON_EFFECT)
        end
    end
end
function c49811311.spcfilter(c,tp)
    return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_FZONE)
        and c:GetReasonPlayer()==1-tp
end
function c49811311.spcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c49811311.spcfilter,1,nil,tp)
end
function c49811311.spfilter(c,e,tp)
    return c:IsSetCard(0x3e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c49811311.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsAbleToExtra() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c49811311.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,c,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c49811311.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0
        and c:IsLocation(LOCATION_EXTRA) then
        if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,c49811311.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
        if g:GetCount()>0 then
            Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
        end
    end
end