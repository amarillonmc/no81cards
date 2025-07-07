--神威骑士的物资增援（未解限）
function c24501059.initial_effect(c)
    -- 主要效果
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(24501059,0))
    e1:SetCategory(CATEGORY_DRAW+CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c24501059.tg1)
    e1:SetOperation(c24501059.op1)
    c:RegisterEffect(e1)
    -- 墓地回收
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(24501059,1))
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetCountLimit(1,24501059)
    e2:SetCondition(c24501059.con2)
    e2:SetTarget(c24501059.tg2)
    e2:SetOperation(c24501059.op2)
    c:RegisterEffect(e2)
end
-- 1
function c24501059.filter1(c)
    return c:IsSetCard(0x501) and not c:IsCode(24501059)
end
function c24501059.filter11(c)
    return c:IsSetCard(0x501) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsCode(24501059)
end
function c24501059.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
    local b1=(Duel.GetFlagEffect(tp,24501059)==0) and
        Duel.IsExistingMatchingCard(c24501059.filter1,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler())
    local b2=(Duel.GetFlagEffect(tp,24501060)==0) and
        Duel.IsExistingMatchingCard(c24501059.filter11,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
    if chk==0 then return b1 or b2 end
    local op=aux.SelectFromOptions(tp,
        {b1,aux.Stringid(24501059,2)},
        {b2,aux.Stringid(24501059,3)})
    e:SetLabel(op)
    if op==1 then
        Duel.RegisterFlagEffect(tp,24501059,RESET_PHASE+PHASE_END,0,1)
        Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
        Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
    else
        Duel.RegisterFlagEffect(tp,24501060,RESET_PHASE+PHASE_END,0,1)
        Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
    end
end
function c24501059.op1(e,tp)
    local op=e:GetLabel()
    if op==1 then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
    local g=Duel.SelectMatchingCard(tp,c24501059.filter1,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler())
    if #g>0 then
        Duel.ConfirmCards(1-tp,g)
        Duel.Draw(tp,2,REASON_EFFECT)
        Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD,nil)
    end
    else
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c24501059.filter11),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
        if #g>0 then
            Duel.SendtoHand(g,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,g)
        end
    local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e1:SetTargetRange(1,0)
        e1:SetTarget(c24501059.splimit)
        e1:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(e1,tp)
    end
end
function c24501059.splimit(e,c)
    return c:IsLocation(LOCATION_EXTRA) and not c:IsRace(RACE_MACHINE)
end
-- 2
function c24501059.con2(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) and e:GetHandler():IsReason(REASON_EFFECT)
end
function c24501059.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToHand() end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c24501059.op2(e,tp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SendtoHand(c,nil,REASON_EFFECT)
    end
end
