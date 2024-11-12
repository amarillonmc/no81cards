--ジェネクス・リファクター
function c49811196.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,c49811196.matfilter,1,1)
    c:EnableReviveLimit()
    c:SetSPSummonOnce(49811196)
    --to deck
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(49811196,0))
    e1:SetCategory(CATEGORY_TODECK)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCondition(c49811196.tdcon)
    e1:SetTarget(c49811196.tdtg)
    e1:SetOperation(c49811196.tdop)
    c:RegisterEffect(e1)
    --summon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(49811196,1))
    e2:SetCategory(CATEGORY_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCost(aux.bfgcost)
    e2:SetTarget(c49811196.sumtg)
    e2:SetOperation(c49811196.sumop)
    c:RegisterEffect(e2)
end
function c49811196.matfilter(c)
    return c:IsLinkSetCard(0x2) and c:IsType(TYPE_EFFECT)
end
function c49811196.tdcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c49811196.tdfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c49811196.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c49811196.tdfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c49811196.tdop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c49811196.tdfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil)
    if g:GetCount()>=1 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
        local sg=g:Select(tp,1,5,nil)
        Duel.ConfirmCards(1-tp,sg)
        Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
        Duel.ShuffleDeck(tp)
    end  
end
function c49811196.sumfilter(c)
    return c:IsSetCard(0x2) and c:IsSummonable(true,nil)
end
function c49811196.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c49811196.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c49811196.sumop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
    local g=Duel.SelectMatchingCard(tp,c49811196.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
    local tc=g:GetFirst()
    if tc then
        Duel.Summon(tp,tc,true,nil)
    end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c49811196.splimit)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function c49811196.splimit(e,c,sump,sumtype,sumpos,targetp)
    return c:IsLocation(LOCATION_HAND+LOCATION_DECK) and not c:IsSetCard(0x2)
end