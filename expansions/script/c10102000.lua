local s, id = GetID()

function s.initial_effect(c)
    -- ①：对方从手卡特召怪兽时，这张卡从手卡特召 + 自肃
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id, 0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1, id)
    e1:SetCondition(s.spcon)
    e1:SetTarget(s.sptg)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)

    -- ②：召唤·特召成功时，选1只其他怪兽变1星，自己上升所降的等级
    local e2a = Effect.CreateEffect(c)
    e2a:SetDescription(aux.Stringid(id, 1))
    e2a:SetCategory(CATEGORY_LVCHANGE)
    e2a:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
    e2a:SetCode(EVENT_SUMMON_SUCCESS)
    e2a:SetCountLimit(1, id + 1)
    e2a:SetTarget(s.lvtg)
    e2a:SetOperation(s.lvop)
    c:RegisterEffect(e2a)
    local e2b = e2a:Clone()
    e2b:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2b)

    -- ③：自己战阶/对方主阶，自身7星以上时，无效场上1张卡，自身变5星
    local e3 = Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id, 2))
    e3:SetCategory(CATEGORY_DISABLE)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetRange(LOCATION_MZONE)
    e3:SetHintTiming(TIMING_SPSUMMON, TIMING_BATTLE_START)
    e3:SetCountLimit(1, id + 2)
    e3:SetCondition(s.discon)
    e3:SetTarget(s.distg)
    e3:SetOperation(s.disop)
    c:RegisterEffect(e3)
end

-- ①
function s.spcon(e, tp, eg, ep, ev, re, r, rp)
    return eg:IsExists(function(tc)
        return tc:IsControler(1 - tp) and tc:GetPreviousLocation() & LOCATION_HAND > 0
    end, 1, nil)
end
function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
            and e:GetHandler():IsCanBeSpecialSummoned(e, 0, tp, false, false)
    end
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, e:GetHandler(), 1, 0, 0)
end
function s.spop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP) > 0 then
        -- 自肃：直到下个回合结束时，不是有等级的怪兽（超量·链接）不能从额外卡组特殊召唤
        local e1 = Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e1:SetTargetRange(1, 0)
        e1:SetTarget(s.spfilter)
        e1:SetReset(RESET_PHASE + PHASE_END, 2)
        Duel.RegisterEffect(e1, tp)
    end
end

-- ①的自肃过滤：没有等级的怪兽 = 超量或链接
function s.spfilter(e, c)
    return c:IsType(TYPE_XYZ) or c:IsType(TYPE_LINK)
end

-- ②
function s.lvfilter(c, self)
    return c:IsFaceup() and c:GetLevel() > 0 and c ~= self
end
function s.lvtg(e, tp, eg, ep, ev, re, r, rp, chk)
    local c = e:GetHandler()
    if chk == 0 then
        return Duel.IsExistingTarget(s.lvfilter, tp, LOCATION_MZONE, LOCATION_MZONE, 1, nil, c)
    end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TARGET)
    Duel.SelectTarget(tp, s.lvfilter, tp, LOCATION_MZONE, LOCATION_MZONE, 1, 1, nil, c)
end
function s.lvop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    local tc = Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:GetLevel() > 0 then
        local lv = tc:GetLevel()
        local diff = lv - 1
        if diff > 0 then
            local e1 = Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_UPDATE_LEVEL)
            e1:SetValue(-diff)
            e1:SetReset(RESET_EVENT + RESETS_STANDARD)
            tc:RegisterEffect(e1)

            if c:IsRelateToEffect(e) and c:IsFaceup() then
                local e2 = Effect.CreateEffect(c)
                e2:SetType(EFFECT_TYPE_SINGLE)
                e2:SetCode(EFFECT_UPDATE_LEVEL)
                e2:SetValue(diff)
                e2:SetReset(RESET_EVENT + RESETS_STANDARD)
                c:RegisterEffect(e2)
            end
        end
    end
end

-- ③
function s.discon(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if not c:IsLevelAbove(7) then return false end
    local ph = Duel.GetCurrentPhase()
    return (Duel.GetTurnPlayer() == tp and ph >= PHASE_BATTLE_START and ph <= PHASE_BATTLE)
        or (Duel.GetTurnPlayer() == 1 - tp and (ph == PHASE_MAIN1 or ph == PHASE_MAIN2))
end
function s.distg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.IsExistingTarget(aux.TRUE, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, 1, nil, e:GetHandler())
    end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DISABLE)
    Duel.SelectTarget(tp, aux.TRUE, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, 1, 1, nil, e:GetHandler())
end
function s.disop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    local tc = Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsFaceup() then
        Duel.NegateRelatedChain(tc, RESET_PHASE + PHASE_END)
        local e1 = Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_PHASE + PHASE_END)
        tc:RegisterEffect(e1)
        local e2 = e1:Clone()
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        tc:RegisterEffect(e2)
    end
    if c:IsRelateToEffect(e) and c:IsFaceup() and not c:IsLevel(5) then
        local e3 = Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_CHANGE_LEVEL)
        e3:SetValue(5)
        e3:SetReset(RESET_EVENT + RESETS_STANDARD)
        c:RegisterEffect(e3)
    end
end