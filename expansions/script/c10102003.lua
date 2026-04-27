local s, id = GetID()

function s.initial_effect(c)
    -- ①：被恶魔族怪兽的效果送去墓地时，特召+可选破坏
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id, 0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON + CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_TO_GRAVE)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1, id)
    e1:SetCondition(s.spcon)
    e1:SetTarget(s.sptg)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)

    -- ②：墓地除外自身，赋予4星以下恶魔族直接攻击
    local e2 = Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id, 1))
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1, id + 1)
    e2:SetCost(s.rmcost)
    e2:SetTarget(s.rmtg)
    e2:SetOperation(s.rmop)
    c:RegisterEffect(e2)
end

-- ①条件：被恶魔族怪兽的效果送去墓地
function s.spcon(e, tp, eg, ep, ev, re, r, rp)
    if not re then return false end
    local rc = re:GetHandler()
    return e:GetHandler():IsReason(REASON_EFFECT) 
        and rc:IsRace(RACE_FIEND) 
        and rc:IsType(TYPE_MONSTER)
end

-- ①目标：特召自身
function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
    local c = e:GetHandler()
    if chk == 0 then
        return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
            and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
    end
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, c, 1, 0, 0)
end

-- ①操作：特召，然后可选破坏对方1怪兽
function s.spop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP) > 0 then
        -- 可选破坏
        Duel.BreakEffect()
        if Duel.IsExistingMatchingCard(aux.TRUE, tp, LOCATION_MZONE, LOCATION_MZONE, 1, nil)
            and Duel.SelectYesNo(tp, aux.Stringid(id, 2)) then  -- 提示是否破坏，需在数据库加字符串 id,2
            Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DESTROY)
            local g = Duel.SelectMatchingCard(tp, aux.TRUE, tp, LOCATION_MZONE, LOCATION_MZONE, 1, 1, nil)
            if #g > 0 then
                Duel.Destroy(g, REASON_EFFECT)
            end
        end
    end
end

-- ② cost：把墓地的这张卡除外
function s.rmcost(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return e:GetHandler():IsAbleToRemoveAsCost() end
    Duel.Remove(e:GetHandler(), POS_FACEUP, REASON_COST)
end

-- ②目标过滤：自己场上4星以下表侧恶魔族
function s.dirfilter(c)
    return c:IsFaceup() and c:IsLevelBelow(4) and c:IsRace(RACE_FIEND)
end

-- ②目标检查
function s.rmtg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.IsExistingTarget(s.dirfilter, tp, LOCATION_MZONE, 0, 1, nil)
    end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TARGET)
    Duel.SelectTarget(tp, s.dirfilter, tp, LOCATION_MZONE, 0, 1, 1, nil)
end

-- ②操作：赋予直接攻击
function s.rmop(e, tp, eg, ep, ev, re, r, rp)
    local tc = Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsFaceup() then
        local e1 = Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DIRECT_ATTACK)
        e1:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_END)
        tc:RegisterEffect(e1)
    end
end