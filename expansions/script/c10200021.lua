-- 渊灵回流
function c10200021.initial_effect(c)
    -- Activate
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e0)
    -- 回收额外卡组表侧表示
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(10200021,0))
    e1:SetCategory(CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_TO_GRAVE)
    e1:SetRange(LOCATION_SZONE)
    e1:SetCondition(c10200021.con1)
    e1:SetTarget(c10200021.tg1)
    e1:SetOperation(c10200021.op1)
    c:RegisterEffect(e1)
    -- 回收墓地
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(10200021,1))
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_TO_DECK)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCondition(c10200021.con2)
    e2:SetTarget(c10200021.tg2)
    e2:SetOperation(c10200021.op2)
    c:RegisterEffect(e2)
end
-- 1
function c10200021.con1(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(Card.IsSetCard,1,nil,0xe21)
end
function c10200021.filter1(c,tp)
    return c:IsFaceup() and c:IsSetCard(0xe21) and c:IsAbleToHand()
        and Duel.GetFlagEffect(tp,10200021+c:GetOriginalCode()) ==0
end
function c10200021.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk ==0 then
        return Duel.IsExistingMatchingCard(c10200021.filter1,tp,LOCATION_EXTRA,0,1,nil,tp)
    end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c10200021.op1(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c10200021.filter1,tp,LOCATION_EXTRA,0,1,1,nil,tp)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        local code=g:GetFirst():GetOriginalCode()
        Duel.RegisterFlagEffect(tp,10200021+code,RESET_PHASE+PHASE_END,0,1)
    end
end
-- 2
function c10200021.filter2(c,tp)
    return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_EXTRA) and c:IsSetCard(0xe21) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c10200021.con2(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c10200021.filter2,1,nil,tp)
end
function c10200021.filter3(c,tp)
    return c:IsSetCard(0xe21) and c:IsAbleToHand() and Duel.GetFlagEffect(tp,10200022+c:GetOriginalCode()) ==0
end
function c10200021.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk ==0 then
        return Duel.IsExistingMatchingCard(c10200021.filter3,tp,LOCATION_GRAVE,0,1,nil,tp)
    end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c10200021.op2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c10200021.filter3,tp,LOCATION_GRAVE,0,1,1,nil,tp)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
        local code=g:GetFirst():GetOriginalCode()
        Duel.RegisterFlagEffect(tp,10200022+code,RESET_PHASE+PHASE_END,0,1)
    end
end