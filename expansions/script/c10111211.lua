function c10111211.initial_effect(c)
    -- ①效果：场上有里侧怪兽时从手卡特召
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(10111211,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,10111211)
    e1:SetCondition(c10111211.spcon)
    e1:SetTarget(c10111211.sptg)
    e1:SetOperation(c10111211.spop)
    c:RegisterEffect(e1)
    -- ①效果：自身变为里侧并从墓地特召企鹅怪兽
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(10111211,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_MZONE)
    e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
    e2:SetCountLimit(1,10111212)
    e2:SetCost(c10111211.flipcost)
    e2:SetTarget(c10111211.sptg1)
    e2:SetOperation(c10111211.spop1)
    c:RegisterEffect(e2)
    -- ③效果：反转时改变怪兽表示形式
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(10111211,2))
    e3:SetCategory(CATEGORY_POSITION)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_FLIP)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetTarget(c10111211.postg)
    e3:SetOperation(c10111211.posop)
    c:RegisterEffect(e3)
end
-- 检查场上有里侧怪兽的条件
function c10111211.spcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end

-- 特殊召唤目标检查
function c10111211.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then
        return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
            and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end

-- 特殊召唤操作
function c10111211.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
    end
end
-- 将自身变为里侧的cost
function c10111211.flipcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsCanTurnSet() and c:IsFaceup() end
    Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE)
end

-- 特殊召唤目标检查
function c10111211.spfilter1(c,e,tp)
    return c:IsSetCard(0x5a) and not c:IsCode(10111211) 
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function c10111211.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
            and Duel.IsExistingMatchingCard(c10111211.spfilter1,tp,LOCATION_GRAVE,0,1,nil,e,tp)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end

-- 特殊召唤操作
function c10111211.spop1(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10111211.spfilter1),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    if #g>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
        Duel.ConfirmCards(1-tp,g)
    end
end

-- 目标选择函数
function c10111211.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
    local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end

-- 操作执行函数
function c10111211.posop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
        Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
    end
end