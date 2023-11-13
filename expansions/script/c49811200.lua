--深海の舞い込む
function c49811200.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetDescription(aux.Stringid(49811200,0))
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,49811200+EFFECT_COUNT_CODE_OATH)
    e1:SetCost(c49811200.cost)
    e1:SetTarget(c49811200.target)
    e1:SetOperation(c49811200.activate)
    c:RegisterEffect(e1)
    Duel.AddCustomActivityCounter(49811200,ACTIVITY_CHAIN,c49811200.chainfilter)
end
function c49811200.chainfilter(re,tp,cid)
    local attr=Duel.GetChainInfo(cid,CHAININFO_TRIGGERING_ATTRIBUTE)
    return not (re:IsActiveType(TYPE_MONSTER) and attr&(ATTRIBUTE_ALL-ATTRIBUTE_WATER)~=0)
end
function c49811200.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    e:SetLabel(100)
    if chk==0 then return Duel.GetCustomActivityCount(49811200,tp,ACTIVITY_CHAIN)==0  end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
    e1:SetCode(EFFECT_CANNOT_ACTIVATE)
    e1:SetTargetRange(1,0)
    e1:SetValue(c49811200.aclimit)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function c49811200.aclimit(e,re,tp)
    return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsNonAttribute(ATTRIBUTE_WATER)
end
function c49811200.costfilter(c,e,tp)
    return c:IsLevelBelow(3) and (c:IsRace(RACE_FISH) or c:IsRace(RACE_SEASERPENT) or c:IsRace(RACE_AQUA)) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost() and Duel.IsExistingMatchingCard(c49811200.spfilter,tp,LOCATION_DECK,0,1,nil,c,e,tp)
end
function c49811200.spfilter(c,mc,e,tp)
    return c:IsLevel(mc:GetOriginalLevel()) and not c:IsRace(mc:GetOriginalRace()) and (c:IsRace(RACE_FISH) or c:IsRace(RACE_SEASERPENT) or c:IsRace(RACE_AQUA))
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c49811200.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        if e:GetLabel()~=100 then return false end
        e:SetLabel(0) 
        return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(c49811200.costfilter,tp,LOCATION_DECK,0,1,nil,e,tp) 
    end
    local c=e:GetHandler()
    Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c49811200.costfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    e:SetLabelObject(tc)   
    Duel.SendtoGrave(g,REASON_COST)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end    
function c49811200.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    local rc=e:GetLabelObject()
    local lvl=rc:GetOriginalLevel()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c49811200.spfilter,tp,LOCATION_DECK,0,1,1,nil,rc,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,0)
    e1:SetLabel(lvl)
    e1:SetTarget(c49811200.splimit)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function c49811200.splimit(e,c)
    return c:IsLevelAbove(0) and not c:IsLevel(e:GetLabel())
end