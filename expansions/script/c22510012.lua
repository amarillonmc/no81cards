--机械街
function c22510012.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetRange(LOCATION_FZONE)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetCountLimit(1)
    e4:SetCondition(c22510012.spcon)
    e4:SetTarget(c22510012.lktg)
    e4:SetOperation(c22510012.lkop)
    c:RegisterEffect(e4)
end
function c22510012.spcon(e,tp,eg,ep,ev,re,r,rp)
    local ph=Duel.GetCurrentPhase()
    return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c22510012.lkfilter(c)
    return c:IsSetCard(0xec0) and c:IsFaceup() and c:IsDestructable()
end
function c22510012.lkfilter2(c,e,tp,n)
    return c:IsSetCard(0xec0) and c:IsType(TYPE_LINK) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,true,true) and c:IsLink(n) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c22510012.lktg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c22510012.lkfilter,tp,LOCATION_ONFIELD,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_ONFIELD)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c22510012.lkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectMatchingCard(tp,c22510012.lkfilter,tp,LOCATION_ONFIELD,0,1,99,nil)
    if not g then return end
    local n=Duel.Destroy(g,REASON_EFFECT)
    Duel.Draw(tp,n,REASON_EFFECT)
    if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==4 then
        if Duel.IsExistingMatchingCard(c22510012.lkfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,n) then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
            local sg=Duel.SelectMatchingCard(tp,c22510012.lkfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,n)
            if not sg then return end
            local tc=sg:GetFirst()
            Duel.BreakEffect()
            Duel.SpecialSummon(tc,SUMMON_TYPE_LINK,tp,tp,true,true,POS_FACEUP)
            tc:CompleteProcedure()
        else
            Duel.ConfirmCards(1-tp,Duel.GetFieldGroup(tp,LOCATION_EXTRA,0))
        end
    end
end
