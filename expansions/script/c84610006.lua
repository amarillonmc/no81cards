--Ｆ・ＨＥＲＯ　リマーカブル
function c84610006.initial_effect(c)
    --spsummon proc
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c84610006.hspcon)
    e1:SetOperation(c84610006.hspop)
    c:RegisterEffect(e1)
    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(84610006,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetCountLimit(1,84610006)   
    e2:SetTarget(c84610006.sptg)
    e2:SetOperation(c84610006.spop)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(84610006,1))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e4:SetCode(EVENT_SUMMON_SUCCESS)
    e4:SetTarget(c84610006.sptg2)
    e4:SetOperation(c84610006.spop2)
    c:RegisterEffect(e4)
    local e5=e4:Clone()
    e5:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e5)
    --summon
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(84610006,2))
    e6:SetCategory(CATEGORY_SUMMON)
    e6:SetType(EFFECT_TYPE_QUICK_O) 
    e6:SetCode(EVENT_FREE_CHAIN)    
    e6:SetRange(LOCATION_MZONE)
    e6:SetCountLimit(1) 
    e6:SetHintTiming(TIMING_MAIN_END,TIMING_MAIN_END)
    e6:SetCondition(c84610006.sumcon)
    e6:SetTarget(c84610006.sumtg)
    e6:SetOperation(c84610006.sumop)
    c:RegisterEffect(e6)
    --destroy
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(84610006,3))
    e7:SetCategory(CATEGORY_DESTROY)
    e7:SetType(EFFECT_TYPE_IGNITION)
    e7:SetRange(LOCATION_HAND+LOCATION_MZONE)
    e7:SetCost(c84610006.descost)
    e7:SetTarget(c84610006.destg)
    e7:SetOperation(c84610006.desop)
    c:RegisterEffect(e7)
end
function c84610006.hspfilter(c,tp)
    return c:IsFaceup() and c:IsCode(40044918) and c:IsAbleToDeckAsCost()
        and Duel.GetMZoneCount(tp,c)>0
end
function c84610006.hspcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.IsExistingMatchingCard(c84610006.hspfilter,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c84610006.hspop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,c84610006.hspfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
    Duel.SendtoDeck(g,POS_FACEUP,1,REASON_COST)
end
function c84610006.spfilter(c,e,tp)
    return c:IsCode(40044918) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c84610006.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():GetFlagEffect(84610006)==0
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c84610006.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
    e:GetHandler():RegisterFlagEffect(84610006,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c84610006.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c84610006.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
end
function c84610006.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():GetFlagEffect(84610006)==0
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c84610006.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
    e:GetHandler():RegisterFlagEffect(84610006,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c84610006.spop2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c84610006.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e2)
    end
    Duel.SpecialSummonComplete()
end
function c84610006.sumcon(e,tp,eg,ep,ev,re,r,rp)
    local ph=Duel.GetCurrentPhase()
    return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function c84610006.sumfilter(c)
    return c:IsSetCard(0x8) and c:IsSummonable(true,nil)
end
function c84610006.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c84610006.sumfilter,tp,LOCATION_HAND,0,1,nil) 
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
    Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c84610006.sumop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
    local g=Duel.SelectMatchingCard(tp,c84610006.sumfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc then
        Duel.Summon(tp,tc,true,nil)
    end
end
function c84610006.descost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsReleasable() end
    Duel.Release(e:GetHandler(),REASON_COST)
end
function c84610006.desfilter(c)
    return c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)
end
function c84610006.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c84610006.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
    local g=Duel.GetMatchingGroup(c84610006.desfilter,tp,0,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c84610006.desop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectMatchingCard(tp,c84610006.desfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
    local tc=g:GetFirst()
    if not tc then return end
    Duel.HintSelection(g)
    Duel.Destroy(g,REASON_EFFECT)
end
