local s, id = GetID()
function s.initial_effect(c)
    -- 激活效果
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id, 0))
    e1:SetCategory(CATEGORY_TOGRAVE + CATEGORY_SEARCH + CATEGORY_TOHAND + CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1, id + EFFECT_COUNT_CODE_OATH) -- 卡名一回合只能发动1张
    e1:SetCost(s.cost) -- 添加cost函数
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
    
    -- 墓地存在时攻击力上升
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x1b))
    e2:SetValue(300)
    c:RegisterEffect(e2)
end

-- 定义幻兽十字翼鸟的卡号
s.crosswing_id = 71181155

-- 添加cost函数：将「幻兽 十字翼鸟」送墓作为cost
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
    Duel.SendtoGrave(g,REASON_COST)
end

-- 卡组送墓目标
function s.tgfilter(c)
    return c:IsCode(s.crosswing_id) and c:IsAbleToGrave()
end

-- 卡组检索目标
function s.thfilter(c)
    return c:IsSetCard(0x1b) and c:IsRace(RACE_BEAST + RACE_BEASTWARRIOR)
        and not c:IsCode(s.crosswing_id) and c:IsAbleToHand()
end

-- 墓地特殊召唤目标
function s.spfilter(c,e,tp)
    return c:IsRace(RACE_BEAST + RACE_BEASTWARRIOR) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

-- 效果目标
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk == 0 then
        return Duel.IsExistingMatchingCard(s.thfilter, tp, LOCATION_DECK, 0, 1, nil)
    end
    Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
end

-- 效果处理
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    -- 步骤1：从卡组检索「幻兽」怪兽
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
    local g2 = Duel.SelectMatchingCard(tp, s.thfilter, tp, LOCATION_DECK, 0, 1, 1, nil)
    if #g2 > 0 and Duel.SendtoHand(g2, nil, REASON_EFFECT) > 0 then
        Duel.ConfirmCards(1-tp, g2)
        Duel.ShuffleHand(tp)
        
        -- 步骤2：可选特殊召唤墓地兽族/兽战士族怪兽
        local g3 = Duel.GetMatchingGroup(aux.NecroValleyFilter(s.spfilter), tp, LOCATION_GRAVE, 0, nil, e, tp)
        if #g3 > 0 and Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
            and Duel.SelectYesNo(tp, aux.Stringid(id, 1)) then
            Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
            local sg = g3:Select(tp, 1, 1, nil)
            if #sg > 0 then
                Duel.BreakEffect()
                Duel.SpecialSummon(sg, 0, tp, tp, false, false, POS_FACEUP)
            end
        end
    end
end