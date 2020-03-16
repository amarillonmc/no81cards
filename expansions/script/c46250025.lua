--骸星装-端盾
function c46250025.initial_effect(c)
    c:EnableReviveLimit()
    c:SetUniqueOnField(1,0,46250025,LOCATION_MZONE)
    aux.AddXyzProcedure(c,nil,6,2)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_GRAVE)
    e1:SetCondition(Auxiliary.XyzLevelFreeCondition(aux.FilterBoolFunction(Card.IsSetCard,0x1fc0),c46250025.xyzcheck,2,2))
    e1:SetTarget(Auxiliary.XyzLevelFreeTarget(aux.FilterBoolFunction(Card.IsSetCard,0x1fc0),c46250025.xyzcheck,2,2))
    e1:SetOperation(Auxiliary.XyzLevelFreeOperation(aux.FilterBoolFunction(Card.IsSetCard,0x1fc0),c46250025.xyzcheck,2,2))
    e1:SetValue(SUMMON_TYPE_XYZ)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_IMMUNE_EFFECT)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(c46250025.econ)
    e2:SetValue(c46250025.efilter)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e3:SetRange(LOCATION_MZONE)
    e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e3:SetTargetRange(LOCATION_ONFIELD,0)
    e3:SetValue(aux.tgoval)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e5:SetType(EFFECT_TYPE_QUICK_O)
    e5:SetCode(EVENT_FREE_CHAIN)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1)
    e5:SetCost(c46250025.cost)
    e5:SetTarget(c46250025.sptg)
    e5:SetOperation(c46250025.spop)
    c:RegisterEffect(e5)
end
function c46250025.xyzcheck(g)
    return g:GetClassCount(Card.GetLevel)==1
end
function c46250025.econ(e)
    return e:GetHandler():GetOverlayCount()>0
end
function c46250025.efilter(e,te)
    return te:IsActiveType(TYPE_MONSTER+TYPE_SPELL)
end
function c46250025.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) end
    c:RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c46250025.spfilter(c,e,tp)
    return c:IsSetCard(0xfc0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c46250025.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c46250025.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c46250025.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c46250025.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
