-- 渊灵-涡流鳐
function c10200000.initial_effect(c)
    aux.EnablePendulumAttribute(c)
    -- 自爆特招
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(10200000,0))
    e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1,10200000)
    e1:SetTarget(c10200000.tg1)
    e1:SetOperation(c10200000.op1)
    c:RegisterEffect(e1)
    -- 双召炸卡
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(10200000,1))
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetCountLimit(1,10200001)
    e2:SetTarget(c10200000.tg2)
    e2:SetOperation(c10200000.op2)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e3)
    -- 遗言苏生
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(10200000,2))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetCode(EVENT_DESTROYED)
    e4:SetCountLimit(1,10200002)
    e4:SetTarget(c10200000.tg3)
    e4:SetOperation(c10200000.op3)
    c:RegisterEffect(e4)
end
-- 1
function c10200000.filter1(c,e,tp)
    return c:IsSetCard(0xe21) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10200000.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c10200000.filter1,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c10200000.op1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) or Duel.Destroy(c,REASON_EFFECT)==0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c10200000.filter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    if #g>0 then Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) end
end
-- 2
function c10200000.filter2(c)
    return c:IsSetCard(0xe21) and c:IsDestructable()
end
function c10200000.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c10200000.filter2,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_DECK)
end
function c10200000.op2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectMatchingCard(tp,c10200000.filter2,tp,LOCATION_DECK,0,1,1,nil)
    if #g>0 then Duel.Destroy(g,REASON_EFFECT) end
end
-- 3
function c10200000.filter3(c,e,tp)
    return c:IsSetCard(0xe21) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10200000.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c10200000.filter3,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c10200000.op3(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10200000.filter3),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    if #g>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
        Duel.ShuffleDeck(tp)
    end
end