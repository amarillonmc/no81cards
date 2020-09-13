function c89380015.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
    e1:SetTarget(c89380015.cointg)
    e1:SetOperation(c89380015.coinop)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2)
end
function c89380015.coinfilter(c,e,tp)
    return c:IsSetCard(0xcc02) and not c:IsCode(89380015) and c:IsAbleToHand() and Duel.IsExistingMatchingCard(c89380015.coinfilter2,tp,LOCATION_DECK,0,1,nil,e,tp,c)
end
function c89380015.coinfilter2(c,e,tp,tc)
    return c:IsSetCard(0xcc02) and c:IsLevel(4) and not c:IsCode(tc:GetCode()) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c89380015.cointg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c89380015.coinfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_MZONE)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c89380015.coinop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
    local g=Duel.SelectMatchingCard(tp,c89380015.coinfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
    if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)==1 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local tg=Duel.SelectMatchingCard(tp,c89380015.coinfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,g:GetFirst())
        if not tg then return end
        Duel.SpecialSummon(tg,nil,tp,tp,false,false,POS_FACEUP)
    end
end