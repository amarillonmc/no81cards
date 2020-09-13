function c89380007.initial_effect(c)
    c:SetUniqueOnField(1,1,89380007)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_HAND)
    e1:SetCost(c89380007.spcost)
    e1:SetTarget(c89380007.target)
    e1:SetOperation(c89380007.operation)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(89380007,0))
    e2:SetCategory(CATEGORY_ATKCHANGE)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetHintTiming(TIMING_DAMAGE_STEP)
    e2:SetRange(LOCATION_HAND)
    e2:SetCost(c89380007.atkcost)
    e2:SetTarget(c89380007.atktg)
    e2:SetOperation(c89380007.atkop)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_EQUIP)
    e3:SetCode(EFFECT_UPDATE_ATTACK)
    e3:SetValue(500)
    c:RegisterEffect(e3)
end
function c89380007.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsDiscardable() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c89380007.spfilter(c,e,tp)
    return c:IsCode(89380009) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c89380007.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c89380007.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c89380007.eqfilter(c)
    return c:IsCode(89380009) and c:IsFaceup()
end
function c89380007.operation(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
    local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local tc=Duel.GetFirstMatchingCard(c89380007.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
    if not tc then return end
    Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    if Duel.IsExistingMatchingCard(c89380007.eqfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and c:IsLocation(LOCATION_GRAVE) and c:CheckUniqueOnField(tp) and not c:IsForbidden() and Duel.SelectYesNo(tp,aux.Stringid(89380007,0)) then
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
        local g=Duel.SelectMatchingCard(tp,c89380007.eqfilter,tp,LOCATION_MZONE,0,1,1,nil)
        if not (g and Duel.Equip(tp,c,g:GetFirst(),false)) then return end
        local e1=Effect.CreateEffect(g:GetFirst())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
        e1:SetCode(EFFECT_EQUIP_LIMIT)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        e1:SetValue(c89380007.eqlimit)
        c:RegisterEffect(e1)
    end
end
function c89380007.eqlimit(e,c)
    return e:GetOwner()==c
end
function c89380007.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsDiscardable() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c89380007.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c89380007.eqfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c89380007.eqfilter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    Duel.SelectTarget(tp,c89380007.eqfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c89380007.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsFaceup() then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(500)
        e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
    end
    if Duel.IsExistingMatchingCard(c89380007.eqfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and c:IsLocation(LOCATION_GRAVE) and c:CheckUniqueOnField(tp) and not c:IsForbidden() and Duel.SelectYesNo(tp,aux.Stringid(89380007,0)) then
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
        local g=Duel.SelectMatchingCard(tp,c89380007.eqfilter,tp,LOCATION_MZONE,0,1,1,nil)
        if not (g and Duel.Equip(tp,c,g:GetFirst(),false)) then return end
        local e1=Effect.CreateEffect(g:GetFirst())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
        e1:SetCode(EFFECT_EQUIP_LIMIT)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        e1:SetValue(c89380007.eqlimit)
        c:RegisterEffect(e1)
    end
end