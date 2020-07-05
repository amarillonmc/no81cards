--对邪魂兵器 试做原型
function c30000993.initial_effect(c)
    c:SetSPSummonOnce(30000993)
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_REMOVED)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCondition(c30000993.spcon1)
    e1:SetCost(c30000993.cost)
    e1:SetTarget(c30000993.sptg)
    e1:SetOperation(c30000993.spop)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetHintTiming(0,TIMING_END_PHASE)
    e2:SetCondition(c30000993.spcon2)
    c:RegisterEffect(e2)
end

function c30000993.spcon1(e,tp,eg,ep,ev,re,r,rp)
    return not Duel.IsPlayerAffectedByEffect(tp,30000010)
end
function c30000993.spcon2(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsPlayerAffectedByEffect(tp,30000010)
end

function c30000993.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetMatchingGroupCount(Card.IsAbleToDeckOrExtraAsCost,tp,LOCATION_REMOVED,LOCATION_REMOVED,e:GetHandler())>=3 end
     Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeckOrExtraAsCost,tp,LOCATION_REMOVED,LOCATION_REMOVED,3,3,e:GetHandler())
    Duel.SendtoDeck(g,nil,2,REASON_COST)
end

function c30000993.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function c30000993.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsRelateToEffect(e) then
        Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
    end
end
