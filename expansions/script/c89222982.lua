-- 黑之森 怪兽 (卡密89222982)
local s, id = GetID()
if not id then id = 89222982 end

function s.initial_effect(c)
    -- ①：召唤·特殊召唤时，COST送墓+给予伤害
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id, 0))
    e1:SetCategory(CATEGORY_DAMAGE)
    e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetCountLimit(1, id) -- ①效果一回合一次
    e1:SetCost(s.damcost)
    e1:SetTarget(s.damtg)
    e1:SetOperation(s.damop)
    c:RegisterEffect(e1)
    
    local e2 = e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2)
    
    -- ②：手卡·墓地特殊召唤（快速效果）
    local e3 = Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id, 1))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetRange(LOCATION_HAND + LOCATION_GRAVE)
    e3:SetCountLimit(1, id + 100) -- ②效果一回合一次
    e3:SetCondition(s.spcon)
    e3:SetTarget(s.sptg)
    e3:SetOperation(s.spop)
    c:RegisterEffect(e3)
end

-- 效果①：COST - 从卡组送墓「黑之森」魔法·陷阱卡
function s.costfilter(c)
    return c:IsSetCard(0x5aa) and c:IsType(TYPE_SPELL + TYPE_TRAP) and c:IsAbleToGraveAsCost()
end

function s.damcost(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return Duel.IsExistingMatchingCard(s.costfilter, tp, LOCATION_DECK, 0, 1, nil) end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOGRAVE)
    local g = Duel.SelectMatchingCard(tp, s.costfilter, tp, LOCATION_DECK, 0, 1, 1, nil)
    Duel.SendtoGrave(g, REASON_COST)
end

-- 效果①：目标 - 给予对方500伤害
function s.damtg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return true end
    Duel.SetTargetPlayer(1 - tp)
    Duel.SetTargetParam(500)
    Duel.SetOperationInfo(0, CATEGORY_DAMAGE, nil, 0, 1 - tp, 500)
end

function s.damop(e, tp, eg, ep, ev, re, r, rp)
    local p, d = Duel.GetChainInfo(0, CHAININFO_TARGET_PLAYER, CHAININFO_TARGET_PARAM)
    Duel.Damage(p, d, REASON_EFFECT)
end

-- 效果②：特殊召唤条件
function s.spcon(e, tp, eg, ep, ev, re, r, rp)
    -- 自己场上有2只以上表侧「黑之森」怪兽
    return Duel.IsExistingMatchingCard(s.bfilter, tp, LOCATION_MZONE, 0, 2, nil)
end

function s.bfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x5aa) and c:IsType(TYPE_MONSTER)
end

-- 效果②：特殊召唤目标
function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
    local c = e:GetHandler()
    if chk == 0 then
        return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
            and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
    end
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, c, 1, 0, 0)
end

function s.spop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 then
        Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP)
    end
end