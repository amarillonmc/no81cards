--机械蝎
function c22510008.initial_effect(c)
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0xec0),2,2)
    c:EnableReviveLimit()
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(22510008,0))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1,22510008)
    e4:SetCondition(c22510008.spcon)
    e4:SetTarget(c22510008.distg)
    e4:SetOperation(c22510008.disop)
    c:RegisterEffect(e4)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(22510008,1))
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,22511008)
    e1:SetCost(c22510008.eqcost)
    e1:SetTarget(c22510008.settg)
    e1:SetOperation(c22510008.setop)
    c:RegisterEffect(e1)
end
function c22510008.spcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==2
end
function c22510008.spfilter(c,e,tp,zone)
    return c:IsSetCard(0xec0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c22510008.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local zone=c:GetLinkedZone(tp)
    if chk==0 then return Duel.IsExistingMatchingCard(c22510008.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,zone) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c22510008.disop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local zone=c:GetLinkedZone(tp) 
    if not c:IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c22510008.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,zone)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)
        g:GetFirst():CompleteProcedure()
    end
end
function c22510008.eqcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,2,nil) end
    Duel.DiscardHand(tp,Card.IsDiscardable,2,2,REASON_COST+REASON_DISCARD)
end
function c22510008.setfilter(c)
    return c:IsCode(22510010) and c:IsSSetable()
end
function c22510008.settg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c22510008.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c22510008.setop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
    local g=Duel.SelectMatchingCard(tp,c22510008.setfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SSet(tp,g:GetFirst())
    end
end
