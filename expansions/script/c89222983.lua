-- 惩戒
local s, id = GetID()
if not id then id = 89222983 end

function s.initial_effect(c)
    -- 规则上也当作「黑之森」卡使用
    local e0 = Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
    e0:SetCode(EFFECT_ADD_SETCODE)
    e0:SetValue(0x5aa)
    c:RegisterEffect(e0)

    -- 反击陷阱基本设定
    c:SetSPSummonOnce(id)

    ---------- 效果①：召唤无效 ----------
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id, 0))
    e1:SetCategory(CATEGORY_NEGATE + CATEGORY_DESTROY + CATEGORY_DAMAGE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_SUMMON)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP + EFFECT_FLAG_DAMAGE_CAL)
    e1:SetCountLimit(1, id)                     -- 卡名1回合1次
    e1:SetCondition(s.sumcon)
    e1:SetTarget(s.sumtg)
    e1:SetOperation(s.sumop)
    c:RegisterEffect(e1)

    ---------- 效果①：反转召唤无效 ----------
    local e2 = e1:Clone()
    e2:SetCode(EVENT_FLIP_SUMMON)
    c:RegisterEffect(e2)

    ---------- 效果①：特殊召唤无效 ----------
    local e3 = e1:Clone()
    e3:SetCode(EVENT_SPSUMMON)
    c:RegisterEffect(e3)

    ---------- 效果②：回卡组 + 检索 ----------
    local e4 = Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id, 1))
    e4:SetCategory(CATEGORY_TODECK + CATEGORY_SEARCH + CATEGORY_TOHAND)
    e4:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetCode(EVENT_LEAVE_FIELD)
    e4:SetRange(LOCATION_GRAVE)
    e4:SetCountLimit(1, id + 100)              -- ②效果1回合1次
    e4:SetCondition(s.retcon)
    e4:SetTarget(s.rettg)
    e4:SetOperation(s.retop)
    c:RegisterEffect(e4)
end

-- ①条件：自己场上有「小鸟」或「终末鸟」且是对方的召唤
function s.sumcon(e, tp, eg, ep, ev, re, r, rp)
    if ep ~= 1 - tp then return false end
    return Duel.IsExistingMatchingCard(s.condition_filter, tp, LOCATION_MZONE, 0, 1, nil)
end
function s.condition_filter(c)
    return c:IsFaceup() and (c:IsCode(89222982) or c:IsCode(89222991))
end

-- ①目标：将召唤的怪兽设为对象
function s.sumtg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return #eg > 0 end
    Duel.SetTargetCard(eg)
    Duel.SetOperationInfo(0, CATEGORY_NEGATE, eg, 1, 0, 0)
    Duel.SetOperationInfo(0, CATEGORY_DESTROY, eg, 1, 0, 0)
    Duel.SetOperationInfo(0, CATEGORY_DAMAGE, nil, 0, 1 - tp, 1500)
end

-- ①操作：无效召唤、破坏、伤害
function s.sumop(e, tp, eg, ep, ev, re, r, rp)
    local tc = eg:GetFirst()
    if tc and tc:IsRelateToChain() then
        if Duel.NegateSummon(tc) then
            Duel.Destroy(tc, REASON_EFFECT)
            Duel.Damage(1 - tp, 1500, REASON_EFFECT)
        end
    end
end

-- ②条件：自己场上的卡因对方从场上离开，且此卡在墓地
function s.retcon(e, tp, eg, ep, ev, re, r, rp)
    if rp ~= 1 - tp then return false end
    if not eg:IsExists(s.leave_filter, 1, nil, tp) then return false end
    return e:GetHandler():IsLocation(LOCATION_GRAVE)
end
function s.leave_filter(c, tp)
    return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_ONFIELD)
        and c:IsReason(REASON_EFFECT) and not c:IsReason(REASON_RETURN)
end

-- ②目标：自身回卡组，检索
function s.rettg(e, tp, eg, ep, ev, re, r, rp, chk)
    local c = e:GetHandler()
    if chk == 0 then
        return c:IsAbleToDeck()
            and Duel.IsExistingMatchingCard(s.thfilter, tp, LOCATION_DECK, 0, 1, nil)
    end
    Duel.SetOperationInfo(0, CATEGORY_TODECK, c, 1, 0, 0)
    Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
end

-- 检索filter：黑之森魔法陷阱，非永续
function s.thfilter(c)
    return c:IsSetCard(0x5aa) and c:IsType(TYPE_SPELL + TYPE_TRAP)
        and not c:IsType(TYPE_CONTINUOUS)
        and c:IsAbleToHand()
end

-- ②操作
function s.retop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SendtoDeck(c, nil, 0, REASON_EFFECT) ~= 0 then
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
        local g = Duel.SelectMatchingCard(tp, s.thfilter, tp, LOCATION_DECK, 0, 1, 1, nil)
        if #g > 0 then
            Duel.SendtoHand(g, nil, REASON_EFFECT)
            Duel.ConfirmCards(1 - tp, g)
        end
    end
end