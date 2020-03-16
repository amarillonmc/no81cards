--机械工厂
function c22510011.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetRange(LOCATION_SZONE)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
    e4:SetCondition(c22510011.spcon)
    e4:SetTarget(c22510011.lktg)
    e4:SetOperation(c22510011.lkop)
    c:RegisterEffect(e4)
    local e5=e4:Clone()
    e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
    e5:SetCondition(c22510011.spcon2)
    e5:SetTarget(c22510011.lktg2)
    e5:SetOperation(c22510011.lkop2)
    c:RegisterEffect(e5)
end
function c22510011.spcon(e,tp,eg,ep,ev,re,r,rp)
    local ph=Duel.GetCurrentPhase()
    return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==4
end
function c22510011.lkfilter(c,e,tp)
    return c:IsSetCard(0xec0) and c:IsType(TYPE_LINK) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,true,true) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and Duel.IsExistingMatchingCard(c22510011.lkfilter2,tp,LOCATION_DECK,0,c:GetLink(),nil)
end
function c22510011.lkfilter2(c)
    return c:IsSetCard(0xec0) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c22510011.lktg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c22510011.lkfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c22510011.lkop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local xg=Duel.SelectMatchingCard(tp,c22510011.lkfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
    if not xg then return end
    local tc=xg:GetFirst()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local tg=Duel.SelectMatchingCard(tp,c22510011.lkfilter2,tp,LOCATION_DECK,0,tc:GetLink(),tc:GetLink(),nil)
    Duel.SendtoGrave(tg,REASON_EFFECT)
    Duel.BreakEffect()
    Duel.SpecialSummon(tc,SUMMON_TYPE_LINK,tp,tp,true,true,POS_FACEUP)
    tc:CompleteProcedure()
end
function c22510011.spcon2(e,tp,eg,ep,ev,re,r,rp)
    local ph=Duel.GetCurrentPhase()
    return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)~=4
end
function c22510011.lkfilter3(c,e,tp)
    return c:IsSetCard(0xec0) and c:IsType(TYPE_LINK) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,true,true) and Duel.IsExistingMatchingCard(c22510011.lkfilter4,tp,LOCATION_GRAVE,0,c:GetLink(),nil)
end
function c22510011.lkfilter4(c)
    return c:IsSetCard(0xec0) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c22510011.lktg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCountFromEx(tp)>0 and Duel.IsExistingMatchingCard(c22510011.lkfilter3,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c22510011.lkop2(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) or Duel.GetLocationCountFromEx(tp)==0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local xg=Duel.SelectMatchingCard(tp,c22510011.lkfilter3,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
    if not xg then return end
    local tc=xg:GetFirst()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local tg=Duel.SelectMatchingCard(tp,c22510011.lkfilter4,tp,LOCATION_GRAVE,0,tc:GetLink(),tc:GetLink(),nil)
    Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
    Duel.BreakEffect()
    Duel.SpecialSummon(tc,SUMMON_TYPE_LINK,tp,tp,true,true,POS_FACEUP)
    tc:CompleteProcedure()
end
