-- 永燃灯
local s, id = GetID()
if not id then id = 89222986 end

function s.initial_effect(c)
    -- 规则上也当作「黑之森」卡使用
    local e0 = Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
    e0:SetCode(EFFECT_ADD_SETCODE)
    e0:SetValue(0x5aa)
    c:RegisterEffect(e0)

    -- 通常陷阱
    c:SetSPSummonOnce(id)

    -- ①：控制权夺取（自己场上必须有空位）
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id, 0))
    e1:SetCategory(CATEGORY_CONTROL)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCountLimit(1, id)                     -- ①效果1回合1次
    e1:SetCondition(s.ctcon)
    e1:SetTarget(s.cttg)
    e1:SetOperation(s.ctop)
    c:RegisterEffect(e1)

    -- ②：墓地回手（终末鸟特召时）
    local e2 = Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id, 1))
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1, id + 100)              -- ②效果1回合1次
    e2:SetCondition(s.retcon)
    e2:SetTarget(s.rettg)
    e2:SetOperation(s.retop)
    c:RegisterEffect(e2)
end

-- ①条件：自己场上有「黑之森 大鸟」(89222980) 或「黑之森 终末与天启之鸟」(89222991)
function s.ctcon(e, tp, eg, ep, ev, re, r, rp)
    return Duel.IsExistingMatchingCard(s.condition_filter, tp, LOCATION_MZONE, 0, 1, nil)
end
function s.condition_filter(c)
    return c:IsFaceup() and (c:IsCode(89222980) or c:IsCode(89222991))
end

-- ①目标：对方场上1只怪兽 + 自己场上必须有空位
function s.cttg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1 - tp) end
    if chk == 0 then
        -- 必须检查自己场上是否有空位来接收夺取的怪兽
        return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
            and Duel.IsExistingTarget(aux.TRUE, tp, 0, LOCATION_MZONE, 1, nil)
    end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_CONTROL)
    local g = Duel.SelectTarget(tp, aux.TRUE, tp, 0, LOCATION_MZONE, 1, 1, nil)
    Duel.SetOperationInfo(0, CATEGORY_CONTROL, g, 1, 0, 0)
end

-- ①操作：获得控制权直到结束阶段
function s.ctop(e, tp, eg, ep, ev, re, r, rp)
    local tc = Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
        -- 第三个参数 PHASE_END 表示持续到结束阶段，第四个参数 1 表示离场时返回原本控制者
        if Duel.GetControl(tc, tp, PHASE_END, 1) then
            -- 控制权重置时自动归还，无需额外处理
        end
    end
end

-- ②条件：终末鸟 (89222991) 特殊召唤成功
function s.retcon(e, tp, eg, ep, ev, re, r, rp)
    return eg:IsExists(Card.IsCode, 1, nil, 89222991)
end

-- ②目标：自身回手
function s.rettg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return e:GetHandler():IsAbleToHand() end
    Duel.SetOperationInfo(0, CATEGORY_TOHAND, e:GetHandler(), 1, 0, 0)
end

function s.retop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SendtoHand(c, nil, REASON_EFFECT)
    end
end