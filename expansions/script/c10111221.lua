-- 幻兽 护森岩鸮
local s, id = GetID()

function s.initial_effect(c)

    -- 效果①：召唤/特殊召唤成功时发动
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id, 0))
    e1:SetCategory(CATEGORY_TOGRAVE)
    e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetCountLimit(1, id)
    e1:SetTarget(s.tgtg)
    e1:SetOperation(s.tgop)
    c:RegisterEffect(e1)
    local e2 = e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2)

   -- 效果②：场上幻兽被破坏时从墓地发动
    local e3 = Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id, 1))
    e3:SetCategory(CATEGORY_TOHAND + CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_DESTROYED)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP + EFFECT_FLAG_DELAY)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetCountLimit(1, id + 1)
    e3:SetCondition(s.thcon)
    e3:SetTarget(s.thtg)
    e3:SetOperation(s.thop)
    c:RegisterEffect(e3)
end

-- 幻兽字段标识
s.setname = 0x1b  -- 幻兽字段的setcode

function s.tgfilter(c)
    return c:IsSetCard(0x1b) and c:IsType(TYPE_MONSTER) and not c:IsCode(id) and c:IsAbleToGrave()
end

-- 效果①：目标处理
function s.tgtg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.IsExistingMatchingCard(s.tgfilter, tp, LOCATION_DECK, 0, 1, nil)
    end
    Duel.SetOperationInfo(0, CATEGORY_TOGRAVE, nil, 1, tp, LOCATION_DECK)
end

-- 效果①：将幻兽怪兽送入墓地
function s.tgop(e, tp, eg, ep, ev, re, r, rp)
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOGRAVE)
    local g = Duel.SelectMatchingCard(tp, s.tgfilter, tp, LOCATION_DECK, 0, 1, 1, nil)
    if #g > 0 then
        Duel.SendtoGrave(g, REASON_EFFECT)
    end
end

-- 效果②：条件检查（自己场上的幻兽被破坏）
function s.cfilter(c, tp)
    return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE)
        and c:IsPreviousSetCard(s.setname) and (c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT))
end

-- 效果②：触发条件（关键修复）
function s.thcon(e, tp, eg, ep, ev, re, r, rp)
    return eg:IsExists(s.cfilter, 1, nil, tp) and not eg:IsContains(e:GetHandler())
end

-- 效果②：目标处理
function s.thtg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return e:GetHandler():IsAbleToHand() end
    Duel.SetOperationInfo(0, CATEGORY_TOHAND, e:GetHandler(), 1, 0, 0)
    -- 不在这里设置特殊召唤的操作信息，因为它是可选的
end

-- 效果②：特殊召唤筛选（兽族/兽战士族）
function s.spfilter(c, e, tp)
    return (c:IsRace(RACE_BEAST) or c:IsRace(RACE_BEASTWARRIOR))
        and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end

-- 效果②：操作执行
function s.thop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SendtoHand(c, nil, REASON_EFFECT) > 0 then
        c:RegisterFlagEffect(id, RESET_EVENT+RESETS_STANDARD, 0, 1)
        -- 检查是否可以特殊召唤
        if Duel.GetLocationCount(tp, LOCATION_MZONE) <= 0 then return end
        local g = Duel.GetMatchingGroup(aux.NecroValleyFilter(s.spfilter), tp, LOCATION_GRAVE, 0, nil, e, tp)
        if #g > 0 and Duel.SelectYesNo(tp, aux.Stringid(id, 2)) then
            Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
            local sg = g:Select(tp, 1, 1, nil)
            if #sg > 0 then
                Duel.SpecialSummon(sg, 0, tp, tp, false, false, POS_FACEUP)
            end
        end
    end
end