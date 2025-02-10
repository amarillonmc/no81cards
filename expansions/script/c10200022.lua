-- 渊灵归墟
function c10200022.initial_effect(c)
    -- Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    -- 效果无效
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(10200022,0))
    e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_CHAINING)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCondition(c10200022.con1)
    e2:SetTarget(c10200022.tg1)
    e2:SetOperation(c10200022.op1)
    c:RegisterEffect(e2)
    -- 遗言回收
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(10200022,1))
    e3:SetCategory(CATEGORY_TOHAND)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_DESTROYED)
    e3:SetTarget(c10200022.tg2)
    e3:SetOperation(c10200022.op2)
    c:RegisterEffect(e3)
end
-- 1
function c10200022.con1(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsSetCard(0xe21) end,tp,LOCATION_EXTRA,0,1,nil)
        and ep==1-tp and Duel.IsChainDisablable(ev)
end
function c10200022.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_PZONE,0,1,nil,0xe21) end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_PZONE)
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c10200022.op1(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_PZONE,0,1,1,nil,0xe21)
    if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
        if Duel.NegateEffect(ev) then end
    end
end
-- 2
function c10200022.filter2(c)
    return c:IsFaceup() and c:IsSetCard(0xe21) and c:IsType(TYPE_PENDULUM) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c10200022.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c10200022.filter2,tp,LOCATION_EXTRA,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function c10200022.op2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c10200022.filter2,tp,LOCATION_EXTRA,0,1,1,nil)
    if g:GetCount()>0 then Duel.SendtoHand(g,nil,REASON_EFFECT) end
end