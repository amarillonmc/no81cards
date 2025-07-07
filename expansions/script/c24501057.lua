--神威骑士团出击！（未解限）
function c24501057.initial_effect(c)
    -- 增援增援
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(24501057,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c24501057.tg1)
    e1:SetOperation(c24501057.op1)
    c:RegisterEffect(e1)
    -- 墓地回收
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(24501057,1))
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetCountLimit(1,24501058)
    e2:SetCondition(c24501057.con2)
    e2:SetTarget(c24501057.tg2)
    e2:SetOperation(c24501057.op2)
    c:RegisterEffect(e2)
end
-- 1
function c24501057.filter1(c,e,tp)
    return c:IsSetCard(0x501) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c24501057.filter11(c)
    return c:IsSetCard(0x501) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c24501057.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
    local b1=(Duel.GetFlagEffect(tp,24501057)==0) and
        Duel.IsExistingMatchingCard(c24501057.filter1,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp)
    local b2=(Duel.GetFlagEffect(tp,24501058)==0) and
        Duel.IsExistingMatchingCard(c24501057.filter11,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
    if chk==0 then return b1 or b2 end
    local op=aux.SelectFromOptions(tp,
        {b1,aux.Stringid(24501057,2)},
        {b2,aux.Stringid(24501057,3)})
    e:SetLabel(op)
    if op==1 then
        Duel.RegisterFlagEffect(tp,24501057,RESET_PHASE+PHASE_END,0,1)
        Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
    else
        Duel.RegisterFlagEffect(tp,24501058,RESET_PHASE+PHASE_END,0,1)
        Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
    end
end
function c24501057.op1(e,tp)
    local op=e:GetLabel()
    if op==1 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c24501057.filter1),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
        if #g>0 then
            Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
        end
    else
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c24501057.filter11),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
        if #g>0 then
            Duel.SendtoHand(g,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,g)
        end
    end
end
-- 2
function c24501057.con2(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) and e:GetHandler():IsReason(REASON_EFFECT)
end
function c24501057.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToHand() end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c24501057.op2(e,tp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 then
        Duel.ConfirmCards(1-tp,c)
    end
end
