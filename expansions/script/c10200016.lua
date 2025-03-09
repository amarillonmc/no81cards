-- 渊灵引导者-溟海星门
function c10200016.initial_effect(c)
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0xe21),2,2)
    c:EnableReviveLimit()
    -- 战吼检索
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(10200016,0))
    e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCountLimit(1,10200016)
    e1:SetCondition(c10200016.con1)
    e1:SetTarget(c10200016.tg1)
    e1:SetOperation(c10200016.op1)
    c:RegisterEffect(e1)
    -- 抗性提供
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e2:SetTarget(c10200016.etlimit)
    e2:SetValue(aux.tgoval)
    c:RegisterEffect(e2)
    -- 效果无效
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(10200016,2))
    e3:SetCategory(CATEGORY_DISABLE)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetRange(LOCATION_MZONE)
    e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
    e3:SetCountLimit(1,10200017)
    e3:SetCondition(c10200016.con3)
    e3:SetCost(c10200016.cost3)
    e3:SetTarget(c10200016.tg3)
    e3:SetOperation(c10200016.op3)
    c:RegisterEffect(e3)
end
-- 1
function c10200016.con1(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c10200016.filter1(c)
    return c:IsSetCard(0xe21) and c:IsAbleToHand()
end
function c10200016.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingMatchingCard(c10200016.filter1,tp,LOCATION_DECK,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g1=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c10200016.op1(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local g=Duel.SelectMatchingCard(tp,c10200016.filter1,tp,LOCATION_DECK,0,1,1,nil)
        if g:GetCount()>0 then Duel.SendtoHand(g,nil,REASON_EFFECT) Duel.ConfirmCards(1-tp,g) end
    end
end
-- 2
function c10200016.etlimit(e,c)
    return c:IsSetCard(0xe21) and c:IsType(TYPE_PENDULUM) and e:GetHandler():GetLinkedGroup():IsContains(c)
end
-- 3
function c10200016.con3(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,nil)
end
function c10200016.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c10200016.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c10200016.op3(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,nil)
    if #g > 0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
        local tc=g:Select(tp,1,1,nil):GetFirst()
        if tc:IsFaceup() and tc:IsCanBeDisabledByEffect(e,false) then
            Duel.NegateRelatedChain(tc,RESET_TURN_SET)
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
            e1:SetCode(EFFECT_DISABLE)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
            tc:RegisterEffect(e1)
            local e2=Effect.CreateEffect(c)
            e2:SetType(EFFECT_TYPE_SINGLE)
            e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
            e2:SetCode(EFFECT_DISABLE_EFFECT)
            e2:SetValue(RESET_TURN_SET)
            e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
            tc:RegisterEffect(e2)
            if tc:IsType(TYPE_TRAPMONSTER) then
                local e3=Effect.CreateEffect(c)
                e3:SetType(EFFECT_TYPE_SINGLE)
                e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
                e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
                e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
                tc:RegisterEffect(e3)
            end
        end
    end
end