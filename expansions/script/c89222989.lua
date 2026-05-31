-- 监视之眼
local s, id = GetID()
if not id then id = 89222989 end

function s.initial_effect(c)
    -- 规则上也当作「黑之森」卡使用
    local e0 = Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
    e0:SetCode(EFFECT_ADD_SETCODE)
    e0:SetValue(0x5aa)
    c:RegisterEffect(e0)

    -- 永续陷阱激活（无效果，仅用于发动）
    local e_activate = Effect.CreateEffect(c)
    e_activate:SetType(EFFECT_TYPE_ACTIVATE)
    e_activate:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e_activate)

    -- 盖放回合发动额外cost (支付3000LP)
    local e_set = Effect.CreateEffect(c)
    e_set:SetDescription(aux.Stringid(id, 2))
    e_set:SetType(EFFECT_TYPE_SINGLE)
    e_set:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
    e_set:SetProperty(EFFECT_FLAG_SET_AVAILABLE + EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
    e_set:SetCost(s.setcost)
    c:RegisterEffect(e_set)

    -- ①：必发效果 - 对方召唤·特殊召唤怪兽时回复500LP
    local e1_sum = Effect.CreateEffect(c)
    e1_sum:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_F)
    e1_sum:SetCode(EVENT_SUMMON_SUCCESS)
    e1_sum:SetRange(LOCATION_SZONE)
    e1_sum:SetCondition(s.reccon)
    e1_sum:SetOperation(s.recop)
    c:RegisterEffect(e1_sum)

    local e1_spsum = e1_sum:Clone()
    e1_spsum:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e1_spsum)

    -- ②：支付2000LP，无效对方表侧卡
    local e2 = Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id, 0))
    e2:SetCategory(CATEGORY_DISABLE)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCountLimit(1, id)                     -- ②效果1回合1次
    e2:SetCost(s.discost)
    e2:SetTarget(s.distg)
    e2:SetOperation(s.disop)
    c:RegisterEffect(e2)

    -- ③：自己回合，场上存在黑之森怪兽，除外自身回复3000LP
    local e3 = Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id, 1))
    e3:SetCategory(CATEGORY_RECOVER)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetCountLimit(1, id + 100)               -- ③效果1回合1次
    e3:SetCondition(s.healcon)
    e3:SetCost(s.healcost)
    e3:SetTarget(s.healtg)
    e3:SetOperation(s.healop)
    c:RegisterEffect(e3)
end

-- 盖放回合发动cost (支付3000LP)
function s.setcost(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return Duel.CheckLPCost(tp, 3000) end
    Duel.PayLPCost(tp, 3000)
end

-- ①条件：对方召唤/特召怪兽，且自己场上有大鸟(89222980)或终末鸟(89222991)
function s.forestfilter(c)
    return c:IsFaceup() and (c:IsCode(89222980) or c:IsCode(89222991))
end
function s.reccon(e, tp, eg, ep, ev, re, r, rp)
    if ep ~= 1 - tp then return false end   -- 对方召唤
    return Duel.IsExistingMatchingCard(s.forestfilter, tp, LOCATION_MZONE, 0, 1, nil)
end

function s.recop(e, tp, eg, ep, ev, re, r, rp)
    Duel.Recover(tp, 500, REASON_EFFECT)
end

-- ②cost: 支付2000LP
function s.discost(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return Duel.CheckLPCost(tp, 2000) end
    Duel.PayLPCost(tp, 2000)
end

-- ②目标：对方场上1张表侧表示卡
function s.disfilter(c)
    return c:IsFaceup() and c:IsControler(1 - e:GetHandlerPlayer())   -- 注意此处需要传入tp，不能在全局定义，将在目标函数中直接写
end
function s.distg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
    if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1 - tp) and chkc:IsFaceup() end
    if chk == 0 then return Duel.IsExistingTarget(Card.IsFaceup, tp, 0, LOCATION_ONFIELD, 1, nil) end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_FACEUP)
    local g = Duel.SelectTarget(tp, Card.IsFaceup, tp, 0, LOCATION_ONFIELD, 1, 1, nil)
    Duel.SetOperationInfo(0, CATEGORY_DISABLE, g, 1, 0, 0)
end

-- ②操作：目标效果无效直到回合结束
function s.disop(e, tp, eg, ep, ev, re, r, rp)
    local tc = Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsFaceup() then
        -- 对于怪兽，需要禁用效果
        local e1 = Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_END)
        tc:RegisterEffect(e1)
        local e2 = Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_END)
        tc:RegisterEffect(e2)
        -- 如果是魔法陷阱卡，仅需禁用效果（魔法陷阱的发动已经不会再次发生，但永续效果需禁用）
        if tc:IsType(TYPE_SPELL + TYPE_TRAP) then
            -- 对于永续魔法陷阱，还需要使其效果无效
            local e3 = Effect.CreateEffect(e:GetHandler())
            e3:SetType(EFFECT_TYPE_SINGLE)
            e3:SetCode(EFFECT_DISABLE)
            e3:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_END)
            tc:RegisterEffect(e3)
        end
    end
end

-- ③条件：自己回合，且场上有黑之森怪兽
function s.healcon(e, tp, eg, ep, ev, re, r, rp)
    return Duel.GetTurnPlayer() == tp and Duel.IsExistingMatchingCard(Card.IsSetCard, tp, LOCATION_MZONE, 0, 1, nil, 0x5aa)
end

-- ③cost：除外墓地的自身
function s.healcost(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return e:GetHandler():IsAbleToRemoveAsCost() end
    Duel.Remove(e:GetHandler(), POS_FACEUP, REASON_COST)
end

function s.healtg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return true end
    Duel.SetOperationInfo(0, CATEGORY_RECOVER, nil, 0, tp, 3000)
end

function s.healop(e, tp, eg, ep, ev, re, r, rp)
    Duel.Recover(tp, 3000, REASON_EFFECT)
end