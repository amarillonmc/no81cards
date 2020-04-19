--Ｆ・ＨＥＲＯ　アクアフェーミナ
function c84610009.initial_effect(c)
    --spsummon proc
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_GRAVE)
    e1:SetCondition(c84610009.hspcon)
    e1:SetOperation(c84610009.hspop)
    c:RegisterEffect(e1)
    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetTarget(c84610009.sptg)
    e2:SetOperation(c84610009.spop)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e3)
    --special summon
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
    e4:SetType(EFFECT_TYPE_QUICK_O) 
    e4:SetCode(EVENT_FREE_CHAIN)    
    e4:SetHintTiming(TIMING_MAIN_END,TIMING_MAIN_END)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1) 
    e4:SetCost(c84610009.cost)
    e4:SetTarget(c84610009.target1)
    e4:SetOperation(c84610009.activate1)
    c:RegisterEffect(e4)
end
function c84610009.spfilter(c,tp)
    return c:IsFaceup() and c:IsCode(63060238) and c:IsAbleToDeckAsCost()
        and Duel.GetMZoneCount(tp,c)>0
end
function c84610009.hspcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.IsExistingMatchingCard(c84610009.spfilter,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c84610009.hspop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,c84610009.spfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
    Duel.SendtoDeck(g,POS_FACEUP,1,REASON_COST)
end
function c84610009.filter(c,e,tp)
    return c:IsCode(63060238) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c84610009.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c84610009.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c84610009.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c84610009.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
end
function c84610009.cfilter(c)
    return c:IsCode(24094653) and c:IsDiscardable()
end
function c84610009.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c84610009.cfilter,tp,LOCATION_HAND,0,1,nil) end
    Duel.DiscardHand(tp,c84610009.cfilter,1,1,REASON_DISCARD+REASON_COST,nil)
end
function c84610009.scfilter(c,e,tp)
    return c:IsSetCard(0x8) and c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,true,false) and Duel.GetMatchingGroup(c84610009.filter1,tp,LOCATION_MZONE,0,nil,tp,c):GetClassCount(Card.GetCode)>2
end
function c84610009.filter1(c,tp,tc)
    return c:IsSetCard(0x8) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave() and Duel.GetLocationCountFromEx(tp,tp,c,tc)>0
end
function c84610009.target1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c84610009.scfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,3,tp,LOCATION_MZONE)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c84610009.activate1(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c84610009.scfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc then
        local g=Duel.GetMatchingGroup(c84610009.filter1,tp,LOCATION_MZONE,0,nil,tp,tc)
        if g:GetClassCount(Card.GetCode)<3 then return end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
        local tg=g:Select(tp,3,3,nil)
        g:Remove(Card.IsCode,nil,tg:GetFirst():GetCode())
        if Duel.SendtoGrave(tg,REASON_EFFECT)~=0 and tg:IsExists(Card.IsLocation,3,nil,LOCATION_GRAVE) then
            Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,true,false,POS_FACEUP)
            tc:CompleteProcedure()
        end
    end
end
