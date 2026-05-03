-- 伏匿之丝 无尽缠丝阿拉斯塔

local COUNTER_SHELTER = 0x18fd
local COUNTER_ATKDEF = 0x17fd
local COUNTER_DEATHTOUCH = 0x16fd
local COUNTER_BACKUP = 0x15fd
local COUNTER_EXTEND = 0x19fd
local COUNTER_NEST = 0x14fd
local COUNTER_FLY = 0x13fd
local COUNTER_DOUBLE = 0x12fd
local COUNTER_ANTI = 0x11fd
local COUNTER_IMMORTAL = 0x1cfd
local COUNTER_LIFELINK = 0x1bfd
local COUNTER_TRAMPLE = 0x17cd
local COUNTER_TANGLE = 0x1dcd

local TRANSFERABLE_COUNTERS = {
    COUNTER_SHELTER,
    COUNTER_ATKDEF,
    COUNTER_DEATHTOUCH,
    COUNTER_BACKUP,
    COUNTER_EXTEND,
    COUNTER_NEST,
    COUNTER_FLY,
    COUNTER_DOUBLE,
    COUNTER_ANTI,
    COUNTER_IMMORTAL,
    COUNTER_LIFELINK,
    COUNTER_TRAMPLE,
}

local ALL_COUNTERS = {
    COUNTER_SHELTER,
    COUNTER_ATKDEF,
    COUNTER_DEATHTOUCH,
    COUNTER_BACKUP,
    COUNTER_EXTEND,
    COUNTER_NEST,
    COUNTER_FLY,
    COUNTER_DOUBLE,
    COUNTER_ANTI,
    COUNTER_IMMORTAL,
    COUNTER_LIFELINK,
    COUNTER_TRAMPLE,
    COUNTER_TANGLE,
}

local TEXT_ASK_TRANSFER = 3 
local TEXT_TRANSFER_SHELTER = 4
local TEXT_TRANSFER_ATKDEF = 5
local TEXT_TRANSFER_DEATHTOUCH = 6
local TEXT_TRANSFER_BACKUP = 7
local TEXT_TRANSFER_EXTEND = 8
local TEXT_TRANSFER_NEST = 9
local TEXT_TRANSFER_FLY = 10
local TEXT_TRANSFER_DOUBLE = 11
local TEXT_TRANSFER_ANTI = 12
local TEXT_TRANSFER_IMMORTAL = 13
local TEXT_TRANSFER_LIFELINK = 14
local TEXT_TRANSFER_TRAMPLE = 15

local CT_TEXT_ID = {
    [COUNTER_SHELTER] = TEXT_TRANSFER_SHELTER,
    [COUNTER_ATKDEF] = TEXT_TRANSFER_ATKDEF,
    [COUNTER_DEATHTOUCH] = TEXT_TRANSFER_DEATHTOUCH,
    [COUNTER_BACKUP] = TEXT_TRANSFER_BACKUP,
    [COUNTER_EXTEND] = TEXT_TRANSFER_EXTEND,
    [COUNTER_NEST] = TEXT_TRANSFER_NEST,
    [COUNTER_FLY] = TEXT_TRANSFER_FLY,
    [COUNTER_DOUBLE] = TEXT_TRANSFER_DOUBLE,
    [COUNTER_ANTI] = TEXT_TRANSFER_ANTI,
    [COUNTER_IMMORTAL] = TEXT_TRANSFER_IMMORTAL,
    [COUNTER_LIFELINK] = TEXT_TRANSFER_LIFELINK,
    [COUNTER_TRAMPLE] = TEXT_TRANSFER_TRAMPLE,
}

function c87531235.initial_effect(c)
    for _, ct in ipairs(ALL_COUNTERS) do
        c:EnableCounterPermit(ct)
    end
    c:EnableReviveLimit()

    aux.AddLinkProcedure(c, nil, 2, 3, c87531235.lcheck)
    c:EnableReviveLimit()

    local e_mat = Effect.CreateEffect(c)
    e_mat:SetType(EFFECT_TYPE_SINGLE)
    e_mat:SetCode(EFFECT_MATERIAL_CHECK)
    e_mat:SetValue(c87531235.matcheck)
    c:RegisterEffect(e_mat)

    local e_inherit = Effect.CreateEffect(c)
    e_inherit:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_CONTINUOUS)
    e_inherit:SetCode(EVENT_SPSUMMON_SUCCESS)
    e_inherit:SetOperation(c87531235.inherit_op)
    c:RegisterEffect(e_inherit)

    -- ①效果
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(87531235, 1))
    e1:SetCategory(CATEGORY_COUNTER + CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_MZONE + LOCATION_SZONE)
    e1:SetCountLimit(1, 87531235)
    e1:SetHintTiming(TIMING_MAIN_END)
    e1:SetCondition(c87531235.maincon)
    e1:SetTarget(c87531235.seltg)
    e1:SetOperation(c87531235.selop)
    c:RegisterEffect(e1)

    -- ②效果
    local e2 = Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(87531235, 0))
    e2:SetCategory(CATEGORY_COUNTER)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_MZONE + LOCATION_SZONE)
    e2:SetCountLimit(1, 87531235 + 100)
    e2:SetHintTiming(0, TIMINGS_CHECK_MONSTER)
    e2:SetCondition(c87531235.tanglecon)
    e2:SetTarget(c87531235.tangletg)
    e2:SetOperation(c87531235.tangleop)
    c:RegisterEffect(e2)

    -- 记录对方本回合发动魔法·陷阱卡的次数
    local e_reset = Effect.CreateEffect(c)
    e_reset:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
    e_reset:SetCode(EVENT_PHASE_START + PHASE_DRAW)
    e_reset:SetOperation(c87531235.resetcount)
    Duel.RegisterEffect(e_reset, 0)

    local e_count = Effect.CreateEffect(c)
    e_count:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
    e_count:SetCode(EVENT_CHAINING)
    e_count:SetOperation(c87531235.countop)
    Duel.RegisterEffect(e_count, 0)
end

function c87531235.lcheck(g, lc)
    local honka = 0
    for tc in aux.Next(g) do
        if tc:IsSetCard(0xf8a) then honka = honka + 1 end
    end
    return honka >= 2
end

function c87531235.matcheck(e, c)
    local mg = c:GetMaterial()
    if not mg or mg:GetCount() == 0 then return end
    local ct_tbl = {}
    for _, ct in ipairs(ALL_COUNTERS) do ct_tbl[ct] = 0 end
    for tc in aux.Next(mg) do
        for _, ct in ipairs(ALL_COUNTERS) do
            local cnt = tc:GetCounter(ct)
            if cnt > 0 then ct_tbl[ct] = ct_tbl[ct] + cnt end
        end
    end
    for ct, total in pairs(ct_tbl) do
        if total > 0 then
            c:RegisterFlagEffect(87531235 + ct, 0, 0, 1, total)
        end
    end
end

function c87531235.inherit_op(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if not c:IsFaceup() then return end
    for _, ct in ipairs(ALL_COUNTERS) do
        local cnt = c:GetFlagEffectLabel(87531235 + ct)
        if cnt and cnt > 0 then
            if c:IsCanAddCounter(ct, cnt) then
                c:AddCounter(ct, cnt, REASON_EFFECT)
            end
            c:ResetFlagEffect(87531235 + ct)
        end
    end
    c87531235.register_counter_effects(c)
end

function c87531235.register_counter_effects(card)
    if card:GetFlagEffect(87531235 + 10000) ~= 0 then return end
    card:RegisterFlagEffect(87531235 + 10000, RESET_EVENT + RESETS_STANDARD, 0, 1)

    local e_atk = Effect.CreateEffect(card)
    e_atk:SetType(EFFECT_TYPE_SINGLE)
    e_atk:SetCode(EFFECT_UPDATE_ATTACK)
    e_atk:SetValue(function(e) return e:GetHandler():GetCounter(COUNTER_ATKDEF) * 400 end)
    e_atk:SetReset(RESET_EVENT + RESETS_STANDARD)
    card:RegisterEffect(e_atk, true)
    local e_def = e_atk:Clone()
    e_def:SetCode(EFFECT_UPDATE_DEFENSE)
    card:RegisterEffect(e_def, true)

    if card:GetCounter(COUNTER_BACKUP) > 0 then
        if card:GetFlagEffect(87531235 + 10001) == 0 then
            card:RegisterFlagEffect(87531235 + 10001, RESET_EVENT + RESETS_STANDARD, 0, 1)
            local e_backup = Effect.CreateEffect(card)
            e_backup:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_CONTINUOUS)
            e_backup:SetCode(EFFECT_DESTROY_REPLACE)
            e_backup:SetTarget(c87531235.backup_target)
            e_backup:SetOperation(c87531235.backup_operation)
            card:RegisterEffect(e_backup, true)
        end
    end

    if card:GetCounter(COUNTER_DEATHTOUCH) > 0 then
        if card:GetFlagEffect(87531235 + 10002) == 0 then
            card:RegisterFlagEffect(87531235 + 10002, RESET_EVENT + RESETS_STANDARD, 0, 1)
            local e_death_battle = Effect.CreateEffect(card)
            e_death_battle:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_CONTINUOUS)
            e_death_battle:SetCode(EVENT_BATTLED)
            e_death_battle:SetCondition(c87531235.death_battle_con)
            e_death_battle:SetOperation(c87531235.death_battle_op)
            card:RegisterEffect(e_death_battle, true)
            local e_death_effect = Effect.CreateEffect(card)
            e_death_effect:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_CONTINUOUS)
            e_death_effect:SetCode(EVENT_CHAIN_SOLVED)
            e_death_effect:SetCondition(c87531235.death_effect_con)
            e_death_effect:SetOperation(c87531235.death_effect_op)
            card:RegisterEffect(e_death_effect, true)
        end
    end

    if card:GetCounter(COUNTER_TRAMPLE) > 0 then
        local e_trample = Effect.CreateEffect(card)
        e_trample:SetType(EFFECT_TYPE_SINGLE)
        e_trample:SetCode(EFFECT_PIERCE)
        card:RegisterEffect(e_trample, true)
    end

    if card:GetCounter(COUNTER_LIFELINK) > 0 then
        if card:GetFlagEffect(87531235 + 10003) == 0 then
            card:RegisterFlagEffect(87531235 + 10003, RESET_EVENT + RESETS_STANDARD, 0, 1)
            local e_lifelink = Effect.CreateEffect(card)
            e_lifelink:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_CONTINUOUS)
            e_lifelink:SetCode(EVENT_BATTLE_DAMAGE)
            e_lifelink:SetCondition(c87531235.lifelink_con)
            e_lifelink:SetOperation(c87531235.lifelink_op)
            card:RegisterEffect(e_lifelink, true)
        end
    end

    if card:GetCounter(COUNTER_IMMORTAL) > 0 then
        local e_ind_battle = Effect.CreateEffect(card)
        e_ind_battle:SetType(EFFECT_TYPE_SINGLE)
        e_ind_battle:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
        e_ind_battle:SetValue(1)
        card:RegisterEffect(e_ind_battle, true)
        local e_ind_effect = e_ind_battle:Clone()
        e_ind_effect:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
        card:RegisterEffect(e_ind_effect, true)
    end

    if card:GetCounter(COUNTER_ANTI) > 0 then
        local e_anti = Effect.CreateEffect(card)
        e_anti:SetType(EFFECT_TYPE_SINGLE)
        e_anti:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
        e_anti:SetValue(aux.tgoval)
        card:RegisterEffect(e_anti, true)
    end

    if card:GetCounter(COUNTER_DOUBLE) > 0 then
        local e_double = Effect.CreateEffect(card)
        e_double:SetType(EFFECT_TYPE_SINGLE)
        e_double:SetCode(EFFECT_EXTRA_ATTACK)
        e_double:SetValue(1)
        card:RegisterEffect(e_double, true)
    end

    if card:GetCounter(COUNTER_FLY) > 0 then
        local e_fly = Effect.CreateEffect(card)
        e_fly:SetType(EFFECT_TYPE_SINGLE)
        e_fly:SetCode(EFFECT_DIRECT_ATTACK)
        card:RegisterEffect(e_fly, true)
    end
end

function c87531235.backup_target(e, tp, eg, ep, ev, re, r, rp, chk)
    local c = e:GetHandler()
    if chk == 0 then
        return c:GetCounter(COUNTER_BACKUP) > 0 and (c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT))
    end
    return Duel.SelectEffectYesNo(tp, c, aux.Stringid(87531215, 5))
end
function c87531235.backup_operation(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    c:RemoveCounter(tp, COUNTER_BACKUP, 1, REASON_EFFECT)
end

function c87531235.death_battle_con(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    local a = Duel.GetAttacker()
    local d = Duel.GetAttackTarget()
    return (a == c and d and d:IsControler(1 - tp)) or (d == c and a and a:IsControler(1 - tp))
end
function c87531235.death_battle_op(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    local a = Duel.GetAttacker()
    local d = Duel.GetAttackTarget()
    local opp = (a == c) and d or a
    if opp and opp:IsRelateToBattle() and opp:IsControler(1 - tp) then
        Duel.Destroy(opp, REASON_EFFECT)
    end
end

function c87531235.death_effect_con(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    local te = Duel.GetChainInfo(ev, CHAININFO_TRIGGERING_EFFECT)
    if not te or te:GetHandler() ~= c then return false end
    if bit.band(te:GetCategory(), CATEGORY_DEFCHANGE) == 0 then return false end
    local tg = Duel.GetChainInfo(ev, CHAININFO_TARGET_CARDS)
    if not tg then return false end
    if tg:IsExists(Card.IsControler, 1, nil, 1 - tp) then
        e:SetLabel(ev)
        return true
    end
    return false
end
function c87531235.death_effect_op(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    local ev = e:GetLabel()
    local te = Duel.GetChainInfo(ev, CHAININFO_TRIGGERING_EFFECT)
    if not te or te:GetHandler() ~= c then return end
    local tg = Duel.GetChainInfo(ev, CHAININFO_TARGET_CARDS)
    if not tg then return end
    local opp_tg = tg:Filter(Card.IsControler, nil, 1 - tp)
    for opp in aux.Next(opp_tg) do
        if opp:IsRelateToChain(ev) then
            Duel.Destroy(opp, REASON_EFFECT)
        end
    end
end

function c87531235.lifelink_con(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    local dam = Duel.GetBattleDamage(tp)
    return dam > 0 and c:GetCounter(COUNTER_LIFELINK) > 0 and c:IsControler(tp)
end
function c87531235.lifelink_op(e, tp, eg, ep, ev, re, r, rp)
    local dam = Duel.GetBattleDamage(tp)
    if dam > 0 then
        Duel.Recover(tp, dam, REASON_EFFECT)
    end
end

function c87531235.maincon(e, tp, eg, ep, ev, re, r, rp)
    local ph = Duel.GetCurrentPhase()
    return (ph == PHASE_MAIN1 or ph == PHASE_MAIN2)
        and (e:GetHandler():IsLocation(LOCATION_MZONE) or e:GetHandler():IsLocation(LOCATION_SZONE))
end

function c87531235.seltg(e, tp, eg, ep, ev, re, r, rp, chk)
    local c = e:GetHandler()
    local b1 = c:IsLocation(LOCATION_MZONE) and Duel.GetLocationCount(tp, LOCATION_SZONE) > 0
    local b2 = c:IsLocation(LOCATION_SZONE) and c:IsType(TYPE_TRAP + TYPE_CONTINUOUS) and Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
    if chk == 0 then return b1 or b2 end

    local op = 0
    if b1 and b2 then
        op = Duel.SelectOption(tp, aux.Stringid(87531235, 1), aux.Stringid(87531235, 2))
    elseif b1 then
        op = Duel.SelectOption(tp, aux.Stringid(87531235, 1))
    else
        op = Duel.SelectOption(tp, aux.Stringid(87531235, 2)) + 1
    end
    e:SetLabel(op)

    if op == 0 then
        if Duel.SelectYesNo(tp, aux.Stringid(87531235, 3)) then
            e:SetProperty(EFFECT_FLAG_CARD_TARGET)
            e:SetCategory(CATEGORY_COUNTER)
            Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TARGET)
            local g = Duel.SelectTarget(tp, function(tc) return tc:IsFaceup() and tc:IsType(TYPE_MONSTER) and tc ~= c end, tp, LOCATION_MZONE, 0, 1, 1, nil)
            Duel.SetOperationInfo(0, CATEGORY_COUNTER, g, 1, 0, 0)
        else
            e:SetProperty(0)
            e:SetCategory(0)
        end
    else
        e:SetProperty(0)
        e:SetCategory(CATEGORY_SPECIAL_SUMMON + CATEGORY_COUNTER)
        Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, c, 1, 0, 0)
    end
end

function c87531235.selop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    local op = e:GetLabel()
    if op == 0 then
        -- 选项A：放置到魔陷区
        if not c:IsRelateToEffect(e) or c:IsLocation(LOCATION_SZONE) or Duel.GetLocationCount(tp, LOCATION_SZONE) <= 0 then return end
        
        -- 检查是否存在其他表侧表示怪兽（用于接收指示物）
        local other_exists = Duel.IsExistingTarget(function(tc) return tc:IsFaceup() and tc:IsType(TYPE_MONSTER) and tc ~= c end, tp, LOCATION_MZONE, 0, 1, nil)
        
        local tc = nil
        -- 只有当存在其他怪兽时，才询问是否转移指示物
        if other_exists then
            if Duel.SelectYesNo(tp, aux.Stringid(87531235, 3)) then
                -- 选择目标怪兽
                Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TARGET)
                local g = Duel.SelectTarget(tp, function(tc) return tc:IsFaceup() and tc:IsType(TYPE_MONSTER) and tc ~= c end, tp, LOCATION_MZONE, 0, 1, 1, nil)
                tc = g:GetFirst()
            end
        end
        
        -- 如果选择了目标怪兽，则转移指示物
        if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
            Duel.HintSelection(Group.FromCards(tc))
            for _, ct in ipairs(TRANSFERABLE_COUNTERS) do
                local cur = c:GetCounter(ct)
                if cur > 0 then
                    if Duel.SelectYesNo(tp, aux.Stringid(87531235, CT_TEXT_ID[ct])) then
                        local list = {}
                        for i = 1, cur do table.insert(list, i) end
                        local ct_remove = Duel.AnnounceNumber(tp, table.unpack(list))
                        if ct_remove > 0 then
                            c:RemoveCounter(tp, ct, ct_remove, REASON_EFFECT)
                            tc:AddCounter(ct, ct_remove, REASON_EFFECT)
                            c87531235.register_counter_effects(tc)
                        end
                    end
                end
            end
        end
        
        -- 移动自身到魔陷区
        Duel.MoveToField(c, tp, tp, LOCATION_SZONE, POS_FACEUP, true)
        local e1 = Effect.CreateEffect(c)
        e1:SetCode(EFFECT_CHANGE_TYPE)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT + RESETS_STANDARD - RESET_TURN_SET)
        e1:SetValue(TYPE_TRAP + TYPE_CONTINUOUS)
        c:RegisterEffect(e1)
    else
        -- 选项B：从魔陷区特召
        if not c:IsRelateToEffect(e) or not c:IsLocation(LOCATION_SZONE) or Duel.GetLocationCount(tp, LOCATION_MZONE) <= 0 then return end
        if Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP) ~= 0 then
            -- 只有存在可转移的指示物时才询问
            local has_transferable = false
            local g = Duel.GetMatchingGroup(
                function(tc)
                    if not tc:IsFaceup() or not tc:IsType(TYPE_MONSTER) or tc == c then return false end
                    for _, ct in ipairs(TRANSFERABLE_COUNTERS) do
                        if tc:GetCounter(ct) > 0 then return true end
                    end
                    return false
                end, tp, LOCATION_MZONE, 0, nil)
            if #g > 0 then
                has_transferable = true
            end
            if has_transferable and Duel.SelectYesNo(tp, aux.Stringid(87531235, TEXT_ASK_TRANSFER)) then
                local continue = true
                while continue do
                    g = Duel.GetMatchingGroup(
                        function(tc)
                            if not tc:IsFaceup() or not tc:IsType(TYPE_MONSTER) or tc == c then return false end
                            for _, ct in ipairs(TRANSFERABLE_COUNTERS) do
                                if tc:GetCounter(ct) > 0 then return true end
                            end
                            return false
                        end, tp, LOCATION_MZONE, 0, nil)
                    if #g == 0 then break end
                    Duel.Hint(HINT_SELECTMSG, tp, aux.Stringid(87531235, TEXT_ASK_TRANSFER))
                    local sc = g:Select(tp, 1, 1, nil):GetFirst()
                    Duel.HintSelection(Group.FromCards(sc))
                    for _, ct in ipairs(TRANSFERABLE_COUNTERS) do
                        local cur = sc:GetCounter(ct)
                        if cur > 0 then
                            if Duel.SelectYesNo(tp, aux.Stringid(87531235, CT_TEXT_ID[ct])) then
                                local list = {}
                                for i = 1, cur do table.insert(list, i) end
                                local ct_remove = Duel.AnnounceNumber(tp, table.unpack(list))
                                if ct_remove > 0 then
                                    sc:RemoveCounter(tp, ct, ct_remove, REASON_EFFECT)
                                    c:AddCounter(ct, ct_remove, REASON_EFFECT)
                                    c87531235.register_counter_effects(c)
                                end
                            end
                        end
                    end
                    continue = Duel.SelectYesNo(tp, aux.Stringid(87531235, TEXT_ASK_TRANSFER))
                end
            end
        end
    end
end

function c87531235.tanglecon(e, tp, eg, ep, ev, re, r, rp)
    return Duel.GetFlagEffect(tp, 87531235) > 0 
end

function c87531235.tangletg(e, tp, eg, ep, ev, re, r, rp, chk)
    local maxct = Duel.GetFlagEffect(tp, 87531235)
    if chk == 0 then
        return maxct > 0 and Duel.IsExistingMatchingCard(Card.IsFaceup, tp, 0, LOCATION_ONFIELD, 1, nil)
    end
    local g = Duel.GetMatchingGroup(Card.IsFaceup, tp, 0, LOCATION_ONFIELD, nil)
    local function filter(c)
        if not c:IsFaceup() then return false end
        if c:IsType(TYPE_MONSTER) then return true end
        if c:IsType(TYPE_SPELL) then
            if c:IsType(TYPE_CONTINUOUS) or c:IsType(TYPE_FIELD) or c:IsType(TYPE_EQUIP) then
                return true
            end
        end
        if c:IsType(TYPE_TRAP) then
            if c:IsType(TYPE_CONTINUOUS) then
                return true
            end
        end
        return false
    end
    g = g:Filter(filter, nil)
    local ct = math.min(maxct, g:GetCount())
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_FACEUP)
    local sg = g:Select(tp, 1, ct, nil)
    Duel.HintSelection(sg)
    e:SetLabel(sg:GetCount())
    Duel.SetTargetCard(sg)
    Duel.SetOperationInfo(0, CATEGORY_COUNTER, sg, sg:GetCount(), 0, 0)
end

function c87531235.tangleop(e, tp, eg, ep, ev, re, r, rp)
    local sg = Duel.GetChainInfo(0, CHAININFO_TARGET_CARDS)
    if not sg or sg:GetCount() == 0 then return end
    Duel.HintSelection(sg)
    for tc in aux.Next(sg) do
        if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsCanAddCounter(COUNTER_TANGLE, 1) then
            tc:AddCounter(COUNTER_TANGLE, 1, REASON_EFFECT)
            local e1 = Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_DISABLE)
            e1:SetReset(RESET_EVENT + RESETS_STANDARD)
            tc:RegisterEffect(e1)
            local e2 = Effect.CreateEffect(e:GetHandler())
            e2:SetType(EFFECT_TYPE_SINGLE)
            e2:SetCode(EFFECT_CANNOT_TRIGGER)
            e2:SetReset(RESET_EVENT + RESETS_STANDARD)
            tc:RegisterEffect(e2)
        end
    end
end

function c87531235.resetcount(e, tp, eg, ep, ev, re, r, rp)
    Duel.ResetFlagEffect(0, 87531235) 
end

function c87531235.countop(e, tp, eg, ep, ev, re, r, rp)
    local te, tgp = Duel.GetChainInfo(ev, CHAININFO_TRIGGERING_EFFECT, CHAININFO_TRIGGERING_PLAYER)
    if te:IsActiveType(TYPE_SPELL + TYPE_TRAP) and tgp == 1 - e:GetHandlerPlayer() then
        Duel.RegisterFlagEffect(e:GetHandlerPlayer(), 87531235, RESET_EVENT, 0, 1)
    end
end