--サイコスペースタイム・オペレーター
function c49811204.initial_effect(c)
    c:EnableReviveLimit()
    --special summon condition
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    c:RegisterEffect(e1)
    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_HAND)
    e2:SetCondition(c49811204.spcon)
    e2:SetTarget(c49811204.sptg)
    e2:SetOperation(c49811204.spop)
    c:RegisterEffect(e2)
    --chaining monster
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(49811204,0))
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_CHAINING)
    e3:SetCountLimit(1,49811204)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(c49811204.condition1)
    e3:SetTarget(c49811204.target1)
    e3:SetOperation(c49811204.operation1)
    c:RegisterEffect(e3)
    --chaining spell & trap
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(49811204,1))
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetCode(EVENT_CHAINING)
    e4:SetCountLimit(1,49811204)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCondition(c49811204.condition2)
    e4:SetTarget(c49811204.target2)
    e4:SetOperation(c49811204.operation2)
    c:RegisterEffect(e4)
    --sp summon banish
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(49811204,2))
    e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e5:SetCode(EVENT_LEAVE_FIELD)
    e5:SetProperty(EFFECT_FLAG_DELAY)
    e5:SetCondition(c49811204.bspcon)
    e5:SetTarget(c49811204.bsptg)
    e5:SetOperation(c49811204.bspop)
    c:RegisterEffect(e5)
end
function c49811204.spfilter(c)
    return c:IsRace(RACE_PSYCHO) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() 
end
function c49811204.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local rg=Duel.GetMatchingGroup(c49811204.spfilter,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE,0,e:GetHandler())
    return rg:CheckSubGroup(aux.mzctcheck,2,2,tp)
end
function c49811204.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
    local g=Duel.GetMatchingGroup(c49811204.spfilter,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE,0,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local sg=g:SelectSubGroup(tp,aux.mzctcheck,true,2,2,tp)
    if sg then
        sg:KeepAlive()
        e:SetLabelObject(sg)
        return true
    else return false end
end
function c49811204.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local g=e:GetLabelObject()
    Duel.Remove(g,POS_FACEUP,REASON_COST)
    g:DeleteGroup()
end
function c49811204.filter1(c)
    return c:IsCode(24707869) and c:IsSSetable()
end
function c49811204.condition1(e,tp,eg,ep,ev,re,r,rp)
    return re:IsActiveType(TYPE_MONSTER) and rp==1-tp
end
function c49811204.target1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c49811204.filter1,tp,LOCATION_DECK,0,1,nil) end
end
function c49811204.operation1(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
    local g=Duel.SelectMatchingCard(tp,c49811204.filter1,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SSet(tp,g:GetFirst())
    end
end
function c49811204.filter2(c)
    return c:IsCode(50292967) and c:IsSSetable()
end
function c49811204.condition2(e,tp,eg,ep,ev,re,r,rp)
    return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and rp==1-tp
end
function c49811204.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c49811204.filter2,tp,LOCATION_DECK,0,1,nil) end
end
function c49811204.operation2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
    local g=Duel.SelectMatchingCard(tp,c49811204.filter2,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SSet(tp,g:GetFirst())
    end
end
function c49811204.bspfilter(c,e,tp)
    return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
        and c:IsFaceup()
end
function c49811204.bspcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsPreviousLocation(LOCATION_MZONE)
        and c:IsPreviousControler(tp) and c:GetReasonPlayer()==1-tp
end
function c49811204.bsptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c49811204.bspfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function c49811204.bspop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c49811204.bspfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil,e,tp)
    if #g>0 then 
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) 
    end
end