-- 伏匿之丝 蛛魔之卵

local COUNTER_SHELTER = 0x18fd
local COUNTER_BACKUP = 0x15fd
local FLAG_COUNT = 87531225 
local FLAG_BACKUP = 87531225 + 1  

function c87531225.initial_effect(c)
    aux.AddLinkProcedure(c, aux.FilterBoolFunction(Card.IsSetCard, 0xf8a), 1, 1)
    c:EnableReviveLimit()
    c:EnableCounterPermit(COUNTER_SHELTER)
    c:EnableCounterPermit(COUNTER_BACKUP)

    -- ①效
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(87531225, 0))
    e1:SetCategory(CATEGORY_COUNTER)
    e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_CHAINING)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1, 87531225)
    e1:SetProperty(EFFECT_FLAG_DELAY + EFFECT_FLAG_CARD_TARGET)
    e1:SetCondition(c87531225.cond_trap_activate)
    e1:SetTarget(c87531225.target1)
    e1:SetOperation(c87531225.operation1)
    c:RegisterEffect(e1)

    local e1b = Effect.CreateEffect(c)
    e1b:SetDescription(aux.Stringid(87531225, 0))
    e1b:SetCategory(CATEGORY_COUNTER)
    e1b:SetType(EFFECT_TYPE_QUICK_O)
    e1b:SetCode(EVENT_FREE_CHAIN)
    e1b:SetRange(LOCATION_MZONE)
    e1b:SetCountLimit(1, 87531225)
    e1b:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1b:SetCondition(c87531225.cond_trap_target)
    e1b:SetTarget(c87531225.target1)
    e1b:SetOperation(c87531225.operation1)
    c:RegisterEffect(e1b)

    -- ②效
    local e_count = Effect.CreateEffect(c)
    e_count:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
    e_count:SetCode(EVENT_CHAINING)
    e_count:SetRange(LOCATION_MZONE)
    e_count:SetOperation(c87531225.countop)
    c:RegisterEffect(e_count)

    local e2 = Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(87531225, 1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON + CATEGORY_DECKDES)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1, 87531225 + 100)
    e2:SetCondition(c87531225.condition2)
    e2:SetTarget(c87531225.target2)
    e2:SetOperation(c87531225.operation2)
    c:RegisterEffect(e2)

    -- ③效
    local e3 = Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_IMMUNE_EFFECT)
    e3:SetRange(LOCATION_MZONE)
    e3:SetValue(c87531225.efilter)
    c:RegisterEffect(e3)
end

function c87531225.cond_trap_activate(e, tp, eg, ep, ev, re, r, rp)
    return re:IsActiveType(TYPE_TRAP)
end

function c87531225.cond_trap_target(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    for i = 1, Duel.GetCurrentChain() do
        local te, tg = Duel.GetChainInfo(i, CHAININFO_TRIGGERING_EFFECT, CHAININFO_TARGET_CARDS)
        if te and te:IsActiveType(TYPE_TRAP) and tg and tg:IsContains(c) then
            return true
        end
    end
    return false
end

function c87531225.target1(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) end
    if chk == 0 then return Duel.IsExistingTarget(aux.TRUE, tp, LOCATION_MZONE, 0, 1, nil) end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TARGET)
    local g = Duel.SelectTarget(tp, aux.TRUE, tp, LOCATION_MZONE, 0, 1, 1, nil)
    Duel.HintSelection(g)
    Duel.SetOperationInfo(0, CATEGORY_COUNTER, g, 1, 0, 0)
end

function c87531225.operation1(e, tp, eg, ep, ev, re, r, rp)
    local tc = Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
        if tc:IsCanAddCounter(COUNTER_SHELTER, 1) then
            tc:AddCounter(COUNTER_SHELTER, 1, REASON_EFFECT)
        end
        if tc:IsCanAddCounter(COUNTER_BACKUP, 1) then
            tc:AddCounter(COUNTER_BACKUP, 1, REASON_EFFECT)
        end
        if tc:GetFlagEffect(FLAG_BACKUP) == 0 then
            local e_replace = Effect.CreateEffect(e:GetHandler())
            e_replace:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_CONTINUOUS)
            e_replace:SetCode(EFFECT_DESTROY_REPLACE)
            e_replace:SetTarget(c87531225.reptg)
            e_replace:SetOperation(c87531225.repop)
            e_replace:SetReset(RESET_EVENT + RESETS_STANDARD)
            e_replace:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  -- 不可无效化
            tc:RegisterEffect(e_replace)
            tc:RegisterFlagEffect(FLAG_BACKUP, RESET_EVENT + RESETS_STANDARD, 0, 1)
        end
    end
end

function c87531225.reptg(e, tp, eg, ep, ev, re, r, rp, chk)
    local c = e:GetHandler()
    if chk == 0 then
        return c:GetCounter(COUNTER_BACKUP) > 0 and (c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT))
    end
    return Duel.SelectEffectYesNo(tp, c, aux.Stringid(87531225, 3))
end

function c87531225.repop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    c:RemoveCounter(tp, COUNTER_BACKUP, 1, REASON_EFFECT)
end

-- ②效果计数
function c87531225.countop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    local tg = Duel.GetChainInfo(ev, CHAININFO_TARGET_CARDS)
    if tg and tg:IsContains(c) then
        c:RegisterFlagEffect(FLAG_COUNT, RESET_CHAIN, 0, 1)
    end
end

function c87531225.condition2(e, tp, eg, ep, ev, re, r, rp)
    return Duel.GetCurrentChain() >= 2 and e:GetHandler():GetFlagEffect(FLAG_COUNT) >= 2
end

function c87531225.spfilter(c, e, tp)
    return c:IsSetCard(0xf8a) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end
function c87531225.trapfilter(c)
    return c:IsSetCard(0xf8a) and c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function c87531225.target2(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c87531225.spfilter), tp, LOCATION_DECK + LOCATION_GRAVE, 0, 1, nil, e, tp)
    end
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_DECK + LOCATION_GRAVE)
    Duel.SetOperationInfo(0, CATEGORY_DECKDES, nil, 0, tp, LOCATION_DECK)
end

function c87531225.operation2(e, tp, eg, ep, ev, re, r, rp)
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
    local g = Duel.SelectMatchingCard(tp, aux.NecroValleyFilter(c87531225.spfilter), tp, LOCATION_DECK + LOCATION_GRAVE, 0, 1, 1, nil, e, tp)
    if #g == 0 then return end
    local tc = g:GetFirst()
    if Duel.SpecialSummon(tc, 0, tp, tp, false, false, POS_FACEUP) ~= 0 then
        local code = tc:GetOriginalCode()
        tc:RegisterFlagEffect(code, RESET_EVENT + RESETS_STANDARD, 0, 1)
        if Duel.IsExistingMatchingCard(c87531225.trapfilter, tp, LOCATION_DECK, 0, 1, nil)
            and Duel.SelectYesNo(tp, aux.Stringid(87531225, 2)) then
            Duel.BreakEffect()
            Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SET)
            local tg = Duel.SelectMatchingCard(tp, c87531225.trapfilter, tp, LOCATION_DECK, 0, 1, 1, nil)
            if #tg > 0 then
                Duel.SSet(tp, tg)
                local stc = tg:GetFirst()
                local e1 = Effect.CreateEffect(e:GetHandler())
                e1:SetDescription(aux.Stringid(87531225, 4))
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
                e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
                e1:SetReset(RESET_EVENT + RESETS_STANDARD)
                stc:RegisterEffect(e1)
            end
        end
    end
end

function c87531225.efilter(e, re)
    return re:IsActiveType(TYPE_TRAP) and not re:GetHandler():IsSetCard(0xf8a)
end