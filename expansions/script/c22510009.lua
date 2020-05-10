--机械鸭
function c22510009.initial_effect(c)
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0xec0),2)
    c:EnableReviveLimit()
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(22510009,0))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1,22510009)
    e4:SetCondition(c22510009.spcon)
    e4:SetTarget(c22510009.distg)
    e4:SetOperation(c22510009.disop)
    c:RegisterEffect(e4)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(22510009,1))
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,22511009)
    e1:SetCost(c22510009.eqcost)
    e1:SetTarget(c22510009.settg)
    e1:SetOperation(c22510009.setop)
    c:RegisterEffect(e1)
end
function c22510009.spcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==3
end
function c22510009.spfilter(c,e,tp,zone)
    return c:IsSetCard(0xec0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c22510009.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local zone=c:GetLinkedZone(tp)
    if chk==0 then return Duel.IsExistingMatchingCard(c22510009.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,zone) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c22510009.disop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local zone=c:GetLinkedZone(tp) 
    if not c:IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c22510009.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,zone)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)
        g:GetFirst():CompleteProcedure()
    end
end
function c22510009.eqcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,3,nil) end
    Duel.DiscardHand(tp,Card.IsDiscardable,3,3,REASON_COST+REASON_DISCARD)
end
function c22510009.setfilter(c,tp)
    return c:IsCode(22510012) and c:GetActivateEffect():IsActivatable(tp)
end
function c22510009.settg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c22510009.setfilter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c22510009.setop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
    local g=Duel.SelectMatchingCard(tp,c22510009.setfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
    local tc=g:GetFirst()
    if tc then
        local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
        if fc then
            Duel.SendtoGrave(fc,REASON_RULE)
            Duel.BreakEffect()
        end
        Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
        Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
    end
end
