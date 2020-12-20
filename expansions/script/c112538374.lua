function c112538374.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(112538374,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,112538374)
    e1:SetCost(c112538374.spcost)
    e1:SetTarget(c112538374.sptg)
    e1:SetOperation(c112538374.spop)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(112538374,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
    e2:SetCountLimit(1,112538474)
    e2:SetCost(c112538374.hspcost)
    e2:SetTarget(c112538374.hsptg)
    e2:SetOperation(c112538374.hspop)
    c:RegisterEffect(e2)
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_TODECK)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e4:SetRange(LOCATION_REMOVED)
    e4:SetCode(EVENT_PHASE+PHASE_END)
    e4:SetCountLimit(1,112538574)
    e4:SetCondition(c112538374.retcon)
    e4:SetTarget(c112538374.rettg)
    e4:SetOperation(c112538374.retop)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e5:SetCode(EVENT_REMOVE)
    e5:SetCountLimit(1,112538674)
    e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e5:SetTarget(c112538374.thtg)
    e5:SetOperation(c112538374.thop)
    c:RegisterEffect(e5)
end
function c112538374.costfilter(c)
    return c:IsRace(RACE_AQUA) and c:IsDiscardable()
end
function c112538374.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsDiscardable()
        and Duel.IsExistingMatchingCard(c112538374.costfilter,tp,LOCATION_HAND,0,1,c) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
    local g=Duel.SelectMatchingCard(tp,c112538374.costfilter,tp,LOCATION_HAND,0,1,1,c)
    g:AddCard(c)
    Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c112538374.spfilter(c,e,tp)
    return not c:IsCode(112538374) and c:IsSetCard(0x12) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c112538374.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c112538374.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c112538374.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c112538374.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c112538374.rfilter(c)
    return not c:IsCode(112538374) and c:IsRace(RACE_AQUA) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsLevelBelow(2)
        and c:IsAbleToGraveAsCost()
end
function c112538374.hspcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c112538374.rfilter,tp,LOCATION_DECK,0,2,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c112538374.rfilter,tp,LOCATION_DECK,0,2,2,nil)
    Duel.SendtoGrave(g,REASON_COST)
end
function c112538374.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c112538374.hspop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c112538374.retcon(e,tp,eg,ep,ev,re,r,rp)
    return tp~=Duel.GetTurnPlayer()
end
function c112538374.retfilter(c)
    return c:IsRace(RACE_AQUA) and c:IsAbleToDeck()
end
function c112538374.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local g=Duel.GetMatchingGroup(c112538374.retfilter,tp,LOCATION_GRAVE,0,nil)
    g:AddCard(e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c112538374.retop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local sg=Group.CreateGroup()
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        sg:AddCard(c)
    end
    local g=Duel.GetMatchingGroup(c112538374.retfilter,tp,LOCATION_GRAVE,0,nil)
    if g:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
        sg:Merge(g:Select(tp,1,1,nil))
    end
    if sg:GetCount()==2 then
        Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
    end
end
function c112538374.thfilter(c)
    return c:IsRace(RACE_AQUA) and not c:IsCode(112538374) and c:IsAbleToHand()
end
function c112538374.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c112538374.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c112538374.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c112538374.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end