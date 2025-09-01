--灾变的预兆
local cm, m = GetID() -- 移除未使用的o变量

function cm.initial_effect(c)
    -- 基本装备效果
    aux.AddEquipSpellEffect(c, true, true, Card.IsFaceup, nil)

    -- 效果1：破坏装备怪兽才能发动（修改为非取对象效果）从额外卡组把1只怪兽送去墓地或者除外，根据那只怪兽的类型把以下效果适用
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m, 0))
    e1:SetCategory(CATEGORY_REMOVE + CATEGORY_TOGRAVE)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_SZONE)
    e1:SetCost(cm.cost)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.activate)
    c:RegisterEffect(e1)
end

-- 装备限制
function cm.EquipLimit(e, c)
    return c:IsFaceup()
end

-- 破坏装备怪兽的代价
function cm.cost(e, tp, eg, ep, ev, re, r, rp, chk)
    local c = e:GetHandler()
    local c2 = c:GetEquipTarget()
    if chk == 0 then return c2 and c2:IsFaceup() end
    -- 记录被破坏的怪兽信息
    e:SetLabelObject(c2)
    -- 破坏装备怪兽
    Duel.Destroy(c2, REASON_COST)
    return true
end

-- 发动效果（修改为非取对象逻辑）
function cm.activate(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    -- 获取在cost阶段被破坏的怪兽
    local destroyedMonster = e:GetLabelObject()

    -- 从额外卡组选择1只怪兽
    local mg = Duel.GetMatchingGroup(cm.spfilter1, tp, LOCATION_EXTRA, 0, nil)
    if #mg == 0 then return end

    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SELECT)
    local tc2 = mg:Select(tp, 1, 1, nil):GetFirst()
    local opt = tc2:IsAbleToGrave() and Duel.SelectYesNo(tp, aux.Stringid(m, 1))

    local isDisaster = cm.IsDisasterMonster(tc2)

    -- 送去墓地或除外
    if opt then
        Duel.SendtoGrave(tc2, REASON_EFFECT)
    else
        Duel.Remove(tc2, POS_FACEUP, REASON_EFFECT)
    end

    -- 记录处理的怪兽和操作
    if isDisaster and Duel.GetFlagEffect(tp, m) == 0 then
        Duel.RegisterFlagEffect(tp, m, RESET_PHASE + PHASE_END, 0, 1)
        -- 效果3：大灾变怪兽的效果，连锁2以上对方发动的效果处理时
        local e3 = Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS) -- 改为永续效果
        e3:SetCode(EVENT_CHAIN_SOLVING)
        -- 移除永续效果不需要的CountLimit
        e3:SetCondition(cm.spcon)
        e3:SetOperation(function(e, tp, eg, ep, ev, re, r, rp)
            -- 检查是否有可用的特殊召唤位置
            local plague = Duel.GetFirstMatchingCard(
                function(c) return c:IsCode(13000762) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false) end, tp,
                LOCATION_DECK, 0, nil)
            if Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 and plague and Duel.SelectYesNo(tp, aux.Stringid(m, 2)) then
                if plague and Duel.SpecialSummon(plague, 0, tp, tp, false, false, POS_FACEUP) ~= 0 then
                    local extraMonsters = Duel.GetMatchingGroup(function(c)
                        return c:IsSpecialSummonable(0) and c:IsSetCard(0xe09)
                    end, tp, LOCATION_EXTRA, 0, nil, 0)
                    if #extraMonsters > 0 and Duel.SelectYesNo(tp, aux.Stringid(m, 3)) then
                        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
                        local extraMon = extraMonsters:Select(tp, 1, 1, nil):GetFirst()
                        if extraMon then
                            Duel.SpecialSummonRule(tp, extraMon, 0)
                        end
                    else
                        local graveG = Duel.GetMatchingGroup(function(c) return c:IsCode(m) and c:IsAbleToHand() end, tp,
                            LOCATION_GRAVE + LOCATION_REMOVED, 0, nil)
                        if #graveG > 0 then
                            Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
                            local tc = graveG:Select(tp, 1, 1, nil):GetFirst()
                            if tc then
                                Duel.SendtoHand(tc, nil, REASON_EFFECT)
                                Duel.ConfirmCards(1 - tp, tc)
                            end
                        end
                    end
                end
                e:Reset()
            end
        end)
        Duel.RegisterEffect(e3, tp)
    elseif not isDisaster and Duel.GetFlagEffect(tp, m + 1) == 0 then
        Duel.RegisterFlagEffect(tp, m + 1, RESET_PHASE + PHASE_END, 0, 1)
        -- 记录被破坏的怪兽
        if destroyedMonster then
            -- 效果2：非大灾变怪兽的效果
            local e2 = Effect.CreateEffect(c)
            e2:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
            e2:SetCode(EVENT_PHASE + PHASE_END)
            e2:SetReset(EVENT_PHASE + PHASE_END)
            e2:SetCountLimit(1)
            e2:SetOperation(function(e, tp, eg, ep, ev, re, r, rp)
                local c = e:GetHandler()

                -- 破坏自己场上所有怪兽
                local g = Duel.GetFieldGroup(tp, LOCATION_MZONE, 0)
                if #g > 0 then
                    Duel.Destroy(g, REASON_EFFECT)
                end

                -- 特殊召唤被这张卡装备过的怪兽
                local tc = destroyedMonster
                if tc and tc:IsLocation(LOCATION_GRAVE) and Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 then
                    Duel.SpecialSummon(tc, 0, tp, tp, false, false, POS_FACEUP)
                end
            end)
            Duel.RegisterEffect(e2, tp)
        end
    end
end

-- 判断是否为大灾变怪兽
function cm.IsDisasterMonster(c)
    return c:IsSetCard(0xe09)
end

-- 非大灾变怪兽效果的条件
function cm.descon(e, tp, eg, ep, ev, re, r, rp)
    return e:GetHandler():GetFlagEffect(m + 1) > 0
end

-- 非大灾变怪兽效果的操作
function cm.desop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()

    -- 破坏自己场上所有怪兽
    local g = Duel.GetFieldGroup(tp, LOCATION_MZONE, 0)
    if #g > 0 then
        Duel.Destroy(g, REASON_EFFECT)
    end

    -- 特殊召唤被这张卡装备过的怪兽
    local tc = e:GetLabelObject()
    if tc and tc:IsLocation(LOCATION_GRAVE) and Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 then
        Duel.SpecialSummon(tc, 0, tp, tp, false, false, POS_FACEUP)
    end
end

-- 大灾变怪兽效果的条件
function cm.spcon(e, tp, eg, ep, ev, re, r, rp)
    return rp == 1 - tp and Duel.GetCurrentChain() >= 2
end

-- 大灾变怪兽效果的代价
function cm.spcost(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return true end
    e:GetHandler():ResetFlagEffect(m)
end

-- 大灾变怪兽效果的目标
function cm.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return Duel.IsExistingMatchingCard(cm.spfilter, tp, LOCATION_DECK, 0, 1, nil, tp) end
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_DECK)
end

-- 大灾变怪兽效果的操作
function cm.spop(e, tp, eg, ep, ev, re, r, rp)
    -- 从卡组特殊召唤大瘟疫
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
    local g = Duel.SelectMatchingCard(tp, cm.spfilter, tp, LOCATION_DECK, 0, 1, 1, nil, tp)
    if #g > 0 and Duel.SpecialSummon(g, 0, tp, tp, false, false, POS_FACEUP) > 0 then
        -- 选择后续操作
        local opt = Duel.SelectOption(tp, aux.Stringid(m, 2), aux.Stringid(m, 3))

        if opt == 0 then
            -- 从额外卡组让大灾变怪兽进行自身的手续
            -- 这里需要根据具体大灾变怪兽的召唤手续来实现
            Debug.Message("从额外卡组让大灾变怪兽进行自身的手续")
        else
            -- 让墓地或除外状态的这张卡回到手卡
            local c = e:GetHandler()
            if c:IsRelateToEffect(e) and c:IsAbleToHand() then
                Duel.SendtoHand(c, nil, REASON_EFFECT)
                Duel.ConfirmCards(1 - tp, c)
            end
        end
    end
end

-- 大瘟疫的筛选器
function cm.spfilter(c, tp)
    -- 这里需要根据实际的大瘟疫怪兽定义来设置条件
    return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(nil, 0, tp, false, false)
end

function cm.spfilter1(c, tp)
    -- 这里需要根据实际的大瘟疫怪兽定义来设置条件
    return c:IsAbleToRemove(tp, POS_FACEUP, REASON_EFFECT) or c:IsAbleToGrave()
end

-- 效果1的目标设置
function cm.target(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return Duel.GetMatchingGroupCount(cm.spfilter1, tp, LOCATION_EXTRA, 0, nil) > 0 end
    Duel.SetOperationInfo(0, CATEGORY_REMOVE, nil, 1, tp, LOCATION_EXTRA)
    Duel.SetOperationInfo(0, CATEGORY_TOGRAVE, nil, 1, tp, LOCATION_EXTRA)
end
