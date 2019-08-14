--矛盾螺旋
function c60151297.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    --to hand
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(60151297,0))
    e2:SetCategory(CATEGORY_TOGRAVE)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DAMAGE_STEP)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCountLimit(1)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetHintTiming(0,0x1e0)
    e2:SetCondition(c60151297.condition2)
    e2:SetTarget(c60151297.tg)
    e2:SetOperation(c60151297.op)
    c:RegisterEffect(e2)
    --disable search
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CANNOT_TO_HAND)
    e3:SetRange(LOCATION_SZONE)
    e3:SetTargetRange(0,LOCATION_DECK+LOCATION_ONFIELD+LOCATION_OVERLAY+LOCATION_EXTRA+LOCATION_REMOVED+LOCATION_GRAVE)
    e3:SetCondition(c60151297.condition)
    c:RegisterEffect(e3)
    --spsummon
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(60151297,1))
    e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetRange(LOCATION_SZONE)
    e5:SetCountLimit(1,60151297)
    e5:SetCost(c60151297.descost)
    e5:SetTarget(c60151297.sptg)
    e5:SetOperation(c60151297.spop)
    c:RegisterEffect(e5)
end
function c60151297.mfilter(c)
    return c:IsSetCard(0xab23) and c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c60151297.mfilter1(c)
    return c:IsType(TYPE_MONSTER)
end
function c60151297.mfilter2(c)
    return c:IsType(TYPE_MONSTER)
end
function c60151297.condition(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroupCount(c60151297.mfilter,tp,LOCATION_MZONE,0,nil)
    local g1=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
    local g2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
    return g>0 and g1<=g2
end
function c60151297.condition2(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroupCount(c60151297.mfilter,tp,LOCATION_MZONE,0,nil)
    local g1=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
    local g2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
    return g>0 and g1>=g2
end
function c60151297.filter(c)
    return c:IsAbleToGrave()
end
function c60151297.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60151297.filter,tp,0,LOCATION_MZONE,1,nil) end
    local g=Duel.GetMatchingGroup(c60151297.filter,tp,0,LOCATION_MZONE,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c60151297.op(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c60151297.filter,tp,0,LOCATION_MZONE,1,1,nil)
    if g:GetCount()>0 then
        Duel.HintSelection(g)
        Duel.SendtoGrave(g,REASON_EFFECT)
    end
end
function c60151297.condition3(e,tp,eg,ep,ev,re,r,rp)
    return not Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)
end
function c60151297.descost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c60151297.filter2(c,e,tp)
    return c:IsSetCard(0xab23) and c:IsType(TYPE_MONSTER)
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c60151297.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c60151297.filter2,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c60151297.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c60151297.filter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c60151297.sumlimit)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function c60151297.sumlimit(e,c)
    return not c:IsSetCard(0xab23)
end