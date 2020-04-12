--Ｆ・ＨＥＲＯ　リマーカブル
function c84610006.initial_effect(c)
    --spsummon proc
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c84610006.hspcon)
    e1:SetOperation(c84610006.hspop)
    c:RegisterEffect(e1)
    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetTarget(c84610006.sptg)
    e2:SetOperation(c84610006.spop)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e3)
    --summon
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_SUMMON)
    e4:SetType(EFFECT_TYPE_QUICK_O) 
    e4:SetCode(EVENT_FREE_CHAIN)    
    e4:SetHintTiming(TIMING_MAIN_END,TIMING_MAIN_END)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1) 
    e4:SetCondition(c84610006.sccon)
    e4:SetTarget(c84610006.target1)
    e4:SetOperation(c84610006.activate1)
    c:RegisterEffect(e4)
end
function c84610006.spfilter(c,tp)
    return c:IsFaceup() and c:IsCode(40044918) and c:IsAbleToDeckAsCost()
        and Duel.GetMZoneCount(tp,c)>0
end
function c84610006.hspcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.IsExistingMatchingCard(c84610006.spfilter,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c84610006.hspop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,c84610006.spfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
    Duel.SendtoDeck(g,POS_FACEUP,1,REASON_COST)
end
function c84610006.filter(c,e,tp)
    return c:IsCode(40044918) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c84610006.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c84610006.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c84610006.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c84610006.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
end
function c84610006.sccon(e,tp,eg,ep,ev,re,r,rp)
    local ph=Duel.GetCurrentPhase()
    return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function c84610006.filter1(c)
    return c:IsSetCard(0x8) and c:IsSummonable(true,nil)
end
function c84610006.target1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c84610006.filter1,tp,LOCATION_HAND,0,1,nil) 
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
    Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c84610006.activate1(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c84610006.filter1),tp,LOCATION_HAND,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc then
        Duel.Summon(tp,tc,true,nil)
    end
end
