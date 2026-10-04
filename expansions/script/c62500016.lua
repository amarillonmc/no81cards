-- 涔叶泽 (62500016)
-- 暗，3星，念动力族/调整/效果，0/1800
-- 这个卡名的效果1回合只能使用1次。
-- ①：自己·对方回合，把手卡·场上的这张卡解放才能发动。直到回合结束时以下效果适用。这个回合结束以及下个回合结束时，除外状态（里侧）的卡比对方多的玩家可以让自身除外状态的卡全部回到卡组。
-- ●每次自己或对方把效果发动，必须把卡组上面1张卡里侧除外。
-- ●每次自己或对方把怪兽召唤·特殊召唤，必须把额外卡组1张卡里侧除外。
-- ●除外状态（里侧）的卡比对方多的玩家受到的全部伤害变成0。

function c62500016.initial_effect(c)
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(62500016, 0))
    e1:SetCategory(CATEGORY_RELEASE)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_HAND + LOCATION_MZONE)
    e1:SetCountLimit(1, 62500016)
    e1:SetCost(c62500016.cost)
    e1:SetOperation(c62500016.operation)
    c:RegisterEffect(e1)
end

function c62500016.cost(e, tp, eg, ep, ev, re, r, rp, chk)
    local c = e:GetHandler()
    if chk == 0 then return c:IsReleasable() end
    Duel.Release(c, REASON_COST)
end

function c62500016.operation(e, tp, eg, ep, ev, re, r, rp)
    local base_tp = Duel.GetTurnPlayer()

    -- 1. 效果发动时：从发动者卡组顶里侧除外1张
    local e1 = Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_CHAIN_SOLVING)
    e1:SetOperation(c62500016.exclude_deck)
    e1:SetReset(RESET_PHASE + PHASE_END, 1)
    Duel.RegisterEffect(e1, tp)

    -- 2. 任何召唤/特殊召唤成功时：从进行该操作的玩家额外卡组选1张里侧除外
    local e2 = Effect.CreateEffect(e:GetHandler())
    e2:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetOperation(c62500016.summon_check)
    e2:SetReset(RESET_PHASE + PHASE_END, 1)
    Duel.RegisterEffect(e2, tp)

    local e3 = e2:Clone()
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetReset(RESET_PHASE + PHASE_END, 1)
    Duel.RegisterEffect(e3, tp)

    -- 3. 伤害变成0：仅当受伤玩家自身的里侧除外卡多于对方
    -- 战斗伤害 - 自己
    local e4 = Effect.CreateEffect(e:GetHandler())
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e4:SetTargetRange(1, 0)
    e4:SetCondition(c62500016.self_battle_con)
    e4:SetValue(0)
    e4:SetReset(RESET_PHASE + PHASE_END, 1)
    Duel.RegisterEffect(e4, tp)

    -- 战斗伤害 - 对方
    local e5 = Effect.CreateEffect(e:GetHandler())
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
    e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e5:SetTargetRange(0, 1)
    e5:SetCondition(c62500016.opp_battle_con)
    e5:SetValue(0)
    e5:SetReset(RESET_PHASE + PHASE_END, 1)
    Duel.RegisterEffect(e5, tp)

    -- 效果伤害 - 自己
    local e6 = Effect.CreateEffect(e:GetHandler())
    e6:SetType(EFFECT_TYPE_FIELD)
    e6:SetCode(EFFECT_CHANGE_DAMAGE)
    e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e6:SetTargetRange(1, 0)
    e6:SetCondition(c62500016.self_eff_con)
    e6:SetValue(0)
    e6:SetReset(RESET_PHASE + PHASE_END, 1)
    Duel.RegisterEffect(e6, tp)

    -- 效果伤害 - 对方
    local e7 = Effect.CreateEffect(e:GetHandler())
    e7:SetType(EFFECT_TYPE_FIELD)
    e7:SetCode(EFFECT_CHANGE_DAMAGE)
    e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e7:SetTargetRange(0, 1)
    e7:SetCondition(c62500016.opp_eff_con)
    e7:SetValue(0)
    e7:SetReset(RESET_PHASE + PHASE_END, 1)
    Duel.RegisterEffect(e7, tp)

    -- 为防止效果伤害被其他效果修改，额外注册NO_EFFECT_DAMAGE（参考试胆竞速）
    local e8 = Effect.CreateEffect(e:GetHandler())
    e8:SetType(EFFECT_TYPE_FIELD)
    e8:SetCode(EFFECT_NO_EFFECT_DAMAGE)
    e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e8:SetTargetRange(1, 0)
    e8:SetCondition(c62500016.self_eff_con)
    e8:SetReset(RESET_PHASE + PHASE_END, 1)
    Duel.RegisterEffect(e8, tp)

    local e9 = Effect.CreateEffect(e:GetHandler())
    e9:SetType(EFFECT_TYPE_FIELD)
    e9:SetCode(EFFECT_NO_EFFECT_DAMAGE)
    e9:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e9:SetTargetRange(0, 1)
    e9:SetCondition(c62500016.opp_eff_con)
    e9:SetReset(RESET_PHASE + PHASE_END, 1)
    Duel.RegisterEffect(e9, tp)

    -- 4. 回卡组效果：本回合结束及下个回合结束各触发一次
    local e_return = Effect.CreateEffect(e:GetHandler())
    e_return:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
    e_return:SetCode(EVENT_PHASE + PHASE_END)
    e_return:SetLabel(base_tp * 2)   -- 编码 base_tp 和触发次数
    e_return:SetCondition(c62500016.return_con)
    e_return:SetOperation(c62500016.return_op)
    Duel.RegisterEffect(e_return, tp)
end

-- 效果发动时：从发动者卡组顶里侧除外1张
function c62500016.exclude_deck(e, tp, eg, ep, ev, re, r, rp)
    if Duel.GetFieldGroupCount(ep, LOCATION_DECK, 0) > 0 then
        local g = Duel.GetDecktopGroup(ep, 1)
        Duel.DisableShuffleCheck()
        Duel.Remove(g, POS_FACEDOWN_DEFENSE, REASON_EFFECT)
    end
end

-- 召唤/特殊召唤成功时：从进行该操作的玩家额外卡组选1张里侧除外
function c62500016.summon_check(e, tp, eg, ep, ev, re, r, rp)
    local tc = eg:GetFirst()
    if not tc then return end
    local player = tc:GetControler()
    local g = Duel.GetMatchingGroup(nil, player, LOCATION_EXTRA, 0, nil)
    if #g == 0 then return end
    Duel.Hint(HINT_SELECTMSG, player, HINTMSG_REMOVE)
    local sg = g:Select(player, 1, 1, nil)
    if #sg > 0 then
        Duel.DisableShuffleCheck()
        Duel.Remove(sg, POS_FACEDOWN_DEFENSE, REASON_EFFECT)
    end
end

-- 条件函数：自己里侧除外 > 对方
function c62500016.self_more(e)
    local p = e:GetHandlerPlayer()
    local op = 1 - p
    local self_count = Duel.GetMatchingGroupCount(Card.IsFacedown, p, LOCATION_REMOVED, 0, nil)
    local opp_count = Duel.GetMatchingGroupCount(Card.IsFacedown, op, LOCATION_REMOVED, 0, nil)
    return self_count > opp_count
end

-- 条件函数：对方里侧除外 > 自己
function c62500016.opp_more(e)
    local p = e:GetHandlerPlayer()
    local op = 1 - p
    local self_count = Duel.GetMatchingGroupCount(Card.IsFacedown, p, LOCATION_REMOVED, 0, nil)
    local opp_count = Duel.GetMatchingGroupCount(Card.IsFacedown, op, LOCATION_REMOVED, 0, nil)
    return opp_count > self_count
end

-- 战斗伤害条件封装（匹配Effect的Condition参数格式）
function c62500016.self_battle_con(e, tp, eg, ep, ev, re, r, rp)
    return c62500016.self_more(e)
end
function c62500016.opp_battle_con(e, tp, eg, ep, ev, re, r, rp)
    return c62500016.opp_more(e)
end
function c62500016.self_eff_con(e, tp, eg, ep, ev, re, r, rp)
    return c62500016.self_more(e)
end
function c62500016.opp_eff_con(e, tp, eg, ep, ev, re, r, rp)
    return c62500016.opp_more(e)
end

-- 回卡组效果的Condition：只在发动回合结束（第一次）和对方回合结束（第二次）触发
function c62500016.return_con(e, tp, eg, ep, ev, re, r, rp)
    local val = e:GetLabel()
    local base = math.floor(val / 2)
    local count = val % 2
    if count >= 2 then return false end
    local turn = Duel.GetTurnPlayer()
    if count == 0 and turn == base then
        return true
    elseif count == 1 and turn == 1 - base then
        return true
    end
    return false
end

-- 回卡组效果的操作
function c62500016.return_op(e, tp, eg, ep, ev, re, r, rp)
    local p = e:GetOwnerPlayer()
    local op = 1 - p
    local self_count = Duel.GetMatchingGroupCount(Card.IsFacedown, p, LOCATION_REMOVED, 0, nil)
    local opp_count = Duel.GetMatchingGroupCount(Card.IsFacedown, op, LOCATION_REMOVED, 0, nil)

    if self_count > opp_count then
        if Duel.SelectYesNo(p, aux.Stringid(62500016, 1)) then
            local g = Duel.GetMatchingGroup(Card.IsFacedown, p, LOCATION_REMOVED, 0, nil)
            if #g > 0 then
                Duel.SendtoDeck(g, p, 2, REASON_EFFECT)
            end
        end
    elseif opp_count > self_count then
        if Duel.SelectYesNo(op, aux.Stringid(62500016, 2)) then
            local g = Duel.GetMatchingGroup(Card.IsFacedown, op, LOCATION_REMOVED, 0, nil)
            if #g > 0 then
                Duel.SendtoDeck(g, op, 2, REASON_EFFECT)
            end
        end
    end

    -- 更新计数，达到2次后清除
    local val = e:GetLabel()
    local count = val % 2 + 1
    local base = math.floor(val / 2)
    e:SetLabel(base * 2 + count)
    if count >= 2 then
        e:Reset()
    end
end