function c84500033.initial_effect(c)
    c:EnableReviveLimit()
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,84500033)
    e1:SetCost(c84500033.spcost)
    e1:SetTarget(c84500033.target)
    e1:SetOperation(c84500033.operation)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(84500033,0))
    e2:SetCategory(CATEGORY_DRAW+CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(c84500033.drtg)
    e2:SetOperation(c84500033.drop)
    c:RegisterEffect(e2)
end
function c84500033.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsDiscardable() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c84500033.spfilter(c,e,tp)
    return c:IsCode(84500026) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c84500033.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c84500033.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c84500033.operation(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local tc=Duel.GetFirstMatchingCard(c84500033.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
    if not tc then return end
    Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
end
function c84500033.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
    if chk==0 then return g:GetCount()>0 end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c84500033.drop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() then return end
    local n=Duel.Destroy(Duel.GetFieldGroup(tp,0,LOCATION_MZONE),REASON_EFFECT)
    if n>0 then
        Duel.Damage(1-tp,n*200,REASON_EFFECT)
    end
end