--圣兽战队 暴虎黄
local cm, m, o = GetID()
function cm.initial_effect(c)
    -- ①效果：掷骰子特召并装备
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m, 1))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON + CATEGORY_DICE)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1, m)
    e1:SetTarget(cm.sptg)
    e1:SetOperation(cm.spop)
    c:RegisterEffect(e1)

    -- 联合卡限制
    local e21 = Effect.CreateEffect(c)
    e21:SetType(EFFECT_TYPE_SINGLE)
    e21:SetCode(EFFECT_UNION_LIMIT)
    e21:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e21:SetValue(function(e, c)
        return (c:IsControler(e:GetHandlerPlayer())) or e:GetHandler():GetEquipTarget() == c
    end)
    c:RegisterEffect(e21)

    -- ②效果：装备/解除装备
    local e2 = Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m, 1))
    e2:SetCategory(CATEGORY_EQUIP)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_CHAINING)
    e2:SetRange(LOCATION_MZONE + LOCATION_SZONE)
    e2:SetTarget(cm.target)
    e2:SetOperation(cm.operation)
    c:RegisterEffect(e2)
end

-- ①效果：掷骰子特召并装备
function cm.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
    local c = e:GetHandler()
    if chk == 0 then
        return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 and
            c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
    end
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, c, 1, 0, 0)
    Duel.SetOperationInfo(0, CATEGORY_DICE, nil, 0, tp, 1)
end

function cm.spop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    -- 掷骰子
    local dice = Duel.TossDice(tp, 1)
    if c:IsRelateToEffect(e) and Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP) > 0 then
        -- 确定装备目标区域（逆时针计算）
        if dice < 1 or dice > 6 then return end
        local p = tp
        local seq = c:GetSequence() + dice -- 逆时针为+

        -- 处理序列超出范围的情况（逆时针计算，需要绕圈）
        while seq > 4 do
            seq = seq - 5
            p = 1 - p
        end

        -- 获取对应位置的怪兽
        local tc = Duel.GetFieldCard(p, LOCATION_MZONE, seq)

        -- 如果有怪兽，询问是否装备
        if tc then
            if Duel.SelectYesNo(tp, aux.Stringid(m, 3)) then
                if Duel.Equip(tp, tc, c, false) then
                    -- 设置装备限制
                    local e1 = Effect.CreateEffect(c)
                    e1:SetType(EFFECT_TYPE_SINGLE)
                    e1:SetCode(EFFECT_EQUIP_LIMIT)
                    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
                    e1:SetValue(function(e, c) return e:GetOwner() == c end)
                    e1:SetReset(RESET_EVENT + RESETS_STANDARD)
                    tc:RegisterEffect(e1)

                    -- 将怪兽视为装备魔法卡
                    local e2 = Effect.CreateEffect(c)
                    e2:SetType(EFFECT_TYPE_SINGLE)
                    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
                    e2:SetCode(EFFECT_CHANGE_TYPE)
                    e2:SetValue(TYPE_EQUIP + TYPE_SPELL)
                    e2:SetReset(RESET_EVENT + RESETS_STANDARD)
                    tc:RegisterEffect(e2)
                end
            end
        end
    end
end

-- ②效果的条件函数
function cm.condition(e, tp, eg, ep, ev, re, r, rp)
    return Duel.GetCurrentChain() > 0
end

-- ②效果的目标选择函数
function cm.target(e, tp, eg, ep, ev, re, r, rp, chk)
    local c = e:GetHandler()
    local b1 = c:IsLocation(LOCATION_MZONE) and Duel.GetLocationCount(tp, LOCATION_SZONE) > 0
        and Duel.IsExistingTarget(nil, tp, LOCATION_MZONE, 0, 1, c)
    local b2 = c:IsLocation(LOCATION_SZONE) and c:IsFaceup() and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)

    if chk == 0 then
        return (b1 or b2) and c:GetFlagEffect(FLAG_ID_UNION) == 0
    end
    c:RegisterFlagEffect(FLAG_ID_UNION, RESET_EVENT + 0x7e0000 + RESET_PHASE + PHASE_END, 0, 1)

    local op = 0
    if b1 and b2 then
        op = Duel.SelectOption(tp, aux.Stringid(m, 0), aux.Stringid(m, 1))
    elseif b1 then
        op = 0
    else
        op = 1
    end

    e:SetLabel(op)

    if op == 0 then
        -- 装备效果
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_EQUIP)
        local g = Duel.SelectTarget(tp, Card.IsFaceup, tp, LOCATION_MZONE, 0, 1, 1, c)
        Duel.SetOperationInfo(0, CATEGORY_EQUIP, g, 1, 0, 0)
    else
        -- 特殊召唤效果
        Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, c, 1, 0, 0)
    end
end

-- ②效果的操作执行函数
function cm.operation(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    local op = e:GetLabel()

    if op == 0 then
        -- 装备效果
        local tc = Duel.GetFirstTarget()
        if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
            if Duel.Equip(tp, c, tc, false) then
                Auxiliary.SetUnionState(c)

                -- 装备效果：代替破坏
                local e3 = Effect.CreateEffect(c)
                e3:SetType(EFFECT_TYPE_EQUIP)
                e3:SetCode(EFFECT_DESTROY_SUBSTITUTE)
                e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
                e3:SetReset(RESET_EVENT + RESETS_STANDARD)
                e3:SetValue(cm.subval)
                c:RegisterEffect(e3)
            end
        end
    else
        -- 特殊召唤效果
        if c:IsRelateToEffect(e) and Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP) > 0 then
            -- 询问是否破坏怪兽
            if Duel.IsExistingMatchingCard(nil, tp, LOCATION_MZONE, LOCATION_MZONE, 1, nil) and
                Duel.SelectYesNo(tp, aux.Stringid(m, 2)) then
                Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DESTROY)
                local g = Duel.SelectMatchingCard(tp, nil, tp, LOCATION_MZONE, LOCATION_MZONE, 1, 1, nil)
                if #g > 0 then
                    Duel.HintSelection(g)
                    Duel.Destroy(g, REASON_EFFECT)
                end
            end
        end
    end
end

-- 代替破坏效果
function cm.subval(e, re, r, rp)
    return r & REASON_BATTLE + REASON_EFFECT > 0
end
