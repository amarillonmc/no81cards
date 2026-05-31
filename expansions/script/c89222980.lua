-- 黑之森 怪兽 (卡密89222980)
local s, id = GetID()
if not id then id = 89222980 end

function s.initial_effect(c)
    -- ①：召唤·特殊召唤时表侧放置「黑之森」永续魔法·陷阱
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id, 0))
    e1:SetCategory(CATEGORY_LEAVE_DECK)
    e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetCountLimit(1,id) -- 卡名一回合一次
    e1:SetTarget(s.pltg)
    e1:SetOperation(s.plop)
    c:RegisterEffect(e1)
    
    local e2 = e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2)
    
    -- ②：强制攻击此卡的永续效果
    local e3 = Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(0, LOCATION_MZONE)
    e3:SetCode(EFFECT_MUST_ATTACK)
    e3:SetCondition(s.atkcon)
    c:RegisterEffect(e3)
    
    local e4 = e3:Clone()
    e4:SetCode(EFFECT_MUST_ATTACK_MONSTER)
    e4:SetValue(s.atklimit)
    c:RegisterEffect(e4)
    
    -- ③：手卡·墓地特殊召唤 (快速效果)
    local e5 = Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(id, 1))
    e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e5:SetType(EFFECT_TYPE_QUICK_O)
    e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e5:SetCode(EVENT_FREE_CHAIN)
    e5:SetRange(LOCATION_HAND + LOCATION_GRAVE)
    e5:SetCountLimit(1, id+100) -- ③效果一回合一次
    e5:SetCondition(s.spcon)
    e5:SetTarget(s.sptg2)
    e5:SetOperation(s.spop2)
    c:RegisterEffect(e5)
end

-- 效果①：目标 - 从卡组选择「黑之森」永续魔法·陷阱
function s.plfilter(c)
    return c:IsSetCard(0x5aa) and c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) or c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and c:IsSetCard(0x5aa)
        and not c:IsForbidden()
end

function s.pltg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.GetLocationCount(tp, LOCATION_SZONE) > 0
            and Duel.IsExistingMatchingCard(s.plfilter, tp, LOCATION_DECK, 0, 1, nil)
    end
    Duel.SetOperationInfo(0, CATEGORY_LEAVE_DECK, nil, 1, tp, 0)
end

function s.plop(e, tp, eg, ep, ev, re, r, rp)
    if Duel.GetLocationCount(tp, LOCATION_SZONE) <= 0 then return end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOFIELD)
    local g = Duel.SelectMatchingCard(tp, s.plfilter, tp, LOCATION_DECK, 0, 1, 1, nil)
    local tc = g:GetFirst()
    if tc then
        -- 表侧表示放置到魔法陷阱区域
        Duel.MoveToField(tc, tp, tp, LOCATION_SZONE, POS_FACEUP, true)
    end
end

-- 效果②：强制攻击条件
function s.atkcon(e)
    return e:GetHandler():IsFaceup()
end

function s.atklimit(e, c)
    return c == e:GetHandler()
end

-- 效果③：特殊召唤条件
function s.spcon(e, tp, eg, ep, ev, re, r, rp)
    -- 自己场上有2只以上表侧「黑之森」怪兽
    return Duel.IsExistingMatchingCard(s.bfilter, tp, LOCATION_MZONE, 0, 2, nil)
end

function s.bfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x5aa) and c:IsType(TYPE_MONSTER)
end

-- 效果③：特殊召唤目标
function s.sptg2(e, tp, eg, ep, ev, re, r, rp, chk)
    local c = e:GetHandler()
    if chk == 0 then
        return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
            and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
    end
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, c, 1, 0, 0)
end

function s.spop2(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 then
        Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP)
    end
end