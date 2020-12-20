--怒炎壊獣ドゴラン
function c84610028.initial_effect(c)
    c:SetUniqueOnField(1,0,c84610028.uqfilter,LOCATION_MZONE)
    --special summon rule
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetRange(LOCATION_HAND)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
    e1:SetTargetRange(POS_FACEUP_ATTACK,1)
    e1:SetCondition(c84610028.spcon)
    e1:SetOperation(c84610028.spop)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetRange(LOCATION_HAND)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
    e2:SetTargetRange(POS_FACEUP_ATTACK,0)
    e2:SetCondition(c84610028.spcon2)
    c:RegisterEffect(e2)
    --destroy
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetCost(c84610028.descost)
    e3:SetTarget(c84610028.destg)
    e3:SetOperation(c84610028.desop)
    c:RegisterEffect(e3)
end
function c84610028.unlimfilter(c,tp)
    return c:IsCode(84610023) and c:IsFaceup()
end
function c84610028.uqfilter(c)
    if Duel.IsExistingMatchingCard(c84610028.unlimfilter,tp,LOCATION_MZONE+LOCATION_PZONE,LOCATION_MZONE+LOCATION_PZONE,1,nil,tp) then
        return c:IsCode(84610028)
    else
        return c:IsSetCard(0xd3)
    end
end
function c84610028.spfilter(c,tp)
    return c:IsReleasable() and Duel.GetMZoneCount(1-tp,c,tp)>0
end
function c84610028.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.IsExistingMatchingCard(c84610028.spfilter,tp,0,LOCATION_MZONE,1,nil,tp)
end
function c84610028.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g=Duel.SelectMatchingCard(tp,c84610028.spfilter,tp,0,LOCATION_MZONE,1,1,nil,tp)
    Duel.Release(g,REASON_COST)
end
function c84610028.cfilter(c)
    return c:IsFaceup() and c:IsSetCard(0xd3)
end
function c84610028.spcon2(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c84610028.cfilter,tp,0,LOCATION_MZONE,1,nil)
end
function c84610028.descost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x37,3,REASON_COST)
        and e:GetHandler():GetAttackAnnouncedCount()==0 end
    Duel.RemoveCounter(tp,1,1,0x37,3,REASON_COST)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
    e1:SetCode(EFFECT_CANNOT_ATTACK)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
    e:GetHandler():RegisterEffect(e1)
end
function c84610028.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0 end
    local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c84610028.desop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
    Duel.Destroy(g,REASON_EFFECT)
end
