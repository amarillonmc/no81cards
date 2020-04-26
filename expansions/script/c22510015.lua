--机械重启
function c22510015.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DISABLE_SUMMONY)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_SUMMON)
    e1:SetCost(c22510015.cost)
    e1:SetTarget(c22510015.target)
    e1:SetOperation(c22510015.activate)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_FLIP_SUMMON)
    c:RegisterEffect(e2)
    local e3=e1:Clone()
    e3:SetCode(EVENT_SPSUMMON)
    c:RegisterEffect(e3)
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetCode(EFFECT_TRAP_ACT_IN_HAND)
    e6:SetCondition(c22510015.handcon)
    c:RegisterEffect(e6)
end
function c22510015.cfilter(c)
    return c:IsSetCard(0xec0) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c22510015.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c22510015.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c22510015.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
    Duel.SendtoGrave(g,REASON_COST)
end
function c22510015.filter(c,tp)
    return c:GetSummonPlayer()~=tp and c:IsCanTurnSet()
end
function c22510015.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=eg:Filter(c22510015.filter,nil,tp)
    local ct=g:GetCount()
    if chk==0 then return ct>0 end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,ct,0,0)
end
function c22510015.activate(e,tp,eg,ep,ev,re,r,rp)
    local g=eg:Filter(c22510015.filter,nil,tp)
    if not g then return end
    Duel.NegateSummon(g:GetFirst())
end
function c22510015.handcon(e)
    return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_HAND,0)==5
end
