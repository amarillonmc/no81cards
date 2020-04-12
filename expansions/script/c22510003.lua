--机械骑士
function c22510003.initial_effect(c)
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetRange(LOCATION_HAND)
    e3:SetCountLimit(1,22510003)
    e3:SetCondition(c22510003.spcon)
    e3:SetTarget(c22510003.sptg)
    e3:SetOperation(c22510003.spop)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1,22511003)
    e4:SetCost(c22510003.discost)
    e4:SetTarget(c22510003.distg)
    e4:SetOperation(c22510003.disop)
    c:RegisterEffect(e4)
end
function c22510003.spcon(e,tp,eg,ep,ev,re,r,rp)
    local ph=Duel.GetCurrentPhase()
    return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c22510003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,Duel.GetLinkedZone(tp))>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  and e:GetHandler():GetFlagEffect(22510003)==0 end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
    c:RegisterFlagEffect(22510003,RESET_CHAIN,0,1)
end
function c22510003.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local zone=Duel.GetLinkedZone(tp)
    if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0 then
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP,zone)
    end
end
function c22510003.discost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
        g:RemoveCard(e:GetHandler())
        return g:GetCount()>0 and g:FilterCount(Card.IsDiscardable,nil)==g:GetCount()
    end
    local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
    Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c22510003.spfilter(c,e,tp)
    return c:IsSetCard(0xec0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22510003.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c22510003.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c22510003.disop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c22510003.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
