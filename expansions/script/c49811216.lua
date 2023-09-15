--角獣の門
function c49811216.initial_effect(c)
    --activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,49811216)
    e1:SetTarget(c49811216.target)
    e1:SetOperation(c49811216.activate)
    c:RegisterEffect(e1)
    --add or special summon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(49811216,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_REMOVE)
    e2:SetCountLimit(1,49811217)
    e2:SetCondition(c49811216.spcon)
    e2:SetTarget(c49811216.sptg)
    e2:SetOperation(c49811216.spop)
    c:RegisterEffect(e2)
end
function c49811216.filter(c)
    return (c:IsCode(63595262) or c:IsCode(64047146)) and c:IsAbleToHand()
end
function c49811216.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c49811216.filter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c49811216.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c49811216.filter),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
    e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
    e1:SetTarget(c49811216.rmtarget)
    e1:SetTargetRange(0xff,0xff)
    e1:SetValue(LOCATION_REMOVED)
    e1:SetReset(RESET_PHASE+PHASE_END,2)
    Duel.RegisterEffect(e1,tp)
end
function c49811216.rmtarget(e,c)
    return c:IsType(TYPE_SPELL)
end
function c49811216.cfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsRace(RACE_BEAST) and c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)
end
function c49811216.spcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c49811216.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c49811216.dfilter(c,e,tp,ft)
    return c:IsRace(RACE_BEAST) and c:IsType(TYPE_TUNER) and (c:IsAttack(1000) or c:IsDefense(1000)) and (c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function c49811216.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c49811216.dfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,ft) end
end
function c49811216.spop(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c49811216.dfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp,ft)
    local tc=g:GetFirst()
    if tc then
        if ft>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
            and (not tc:IsAbleToHand() or Duel.SelectOption(tp,1190,1152)==1) then
            Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
        else
            Duel.SendtoHand(tc,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,tc)
        end
    end
end