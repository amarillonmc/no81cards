-- 黑之森的守望
local s, id = GetID()
if not id then id = 89222984 end

function s.initial_effect(c)
    -- 速攻魔法
    c:SetSPSummonOnce(id)

    -- 效果① 激活效果（主要阶段 / 通过e2附加cost后对方回合也可用）
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id, 0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON + CATEGORY_TOGRAVE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1, id)                     -- ①效果1回合1次
    e1:SetTarget(s.sptg)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)

    -- 对方回合从手卡发动时，丢弃1张手卡作为额外cost
    local e2 = Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
    e2:SetCondition(s.handcon)
    e2:SetCost(s.handcost)
    e2:SetDescription(aux.Stringid(id, 1))
    c:RegisterEffect(e2)

    -- 效果② 墓地回手（终末鸟特召时）
    local e3 = Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id, 2))
    e3:SetCategory(CATEGORY_TOHAND)
    e3:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetCountLimit(1, id + 100)              -- ②效果1回合1次
    e3:SetCondition(s.retcon)
    e3:SetTarget(s.rettg)
    e3:SetOperation(s.retop)
    c:RegisterEffect(e3)
end

-- 对方回合条件
function s.handcon(e)
    return Duel.GetTurnPlayer() ~= e:GetHandlerPlayer()
end

-- 对方回合手卡发动时的追加cost：丢弃1张手卡
function s.handcost(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.IsExistingMatchingCard(Card.IsDiscardable, tp, LOCATION_HAND, 0, 1, e:GetHandler())
    end
    Duel.DiscardHand(tp, Card.IsDiscardable, 1, 1, REASON_COST + REASON_DISCARD)
end

-- 效果① 目标：从卡组特召
function s.spfilter(c, e, tp)
    return c:IsSetCard(0x5aa) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end

function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
            and Duel.IsExistingMatchingCard(s.spfilter, tp, LOCATION_DECK, 0, 1, nil, e, tp)
    end
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_DECK)
end

function s.spop(e, tp, eg, ep, ev, re, r, rp)
    if Duel.GetLocationCount(tp, LOCATION_MZONE) <= 0 then return end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
    local g = Duel.SelectMatchingCard(tp, s.spfilter, tp, LOCATION_DECK, 0, 1, 1, nil, e, tp)
    local tc = g:GetFirst()
    
    -- 在特召结算成功后，或者处理最后再上自肃，防止自肃卡死本次特召
    if tc and Duel.SpecialSummon(tc, 0, tp, tp, false, false, POS_FACEUP) > 0 then
        -- “那之后”检查场上黑之森怪兽数量
        if Duel.IsExistingMatchingCard(s.forest_filter, tp, LOCATION_MZONE, 0, 2, nil) then
            if Duel.SelectYesNo(tp, aux.Stringid(id, 3)) then
                Duel.BreakEffect()
                Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOGRAVE)
                local sg = Duel.SelectMatchingCard(tp, s.gravefilter, tp, LOCATION_DECK, 0, 1, 1, nil)
                if #sg > 0 then
                    Duel.SendtoGrave(sg, REASON_EFFECT)
                end
            end
        end
    end

    -- 依照参考卡逻辑，在效果处理结束时（或跟随特召成功后）正式烙上自肃
    local e1 = Effect.CreateEffect(e:GetHandler())
    e1:SetDescription(aux.Stringid(id, 4))
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET + EFFECT_FLAG_CLIENT_HINT)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetTargetRange(1, 0)
    e1:SetTarget(s.splimit)
    if Duel.GetTurnPlayer() == tp then
        e1:SetReset(RESET_PHASE + PHASE_END + RESET_SELF_TURN, 2)
    else
        e1:SetReset(RESET_PHASE + PHASE_END + RESET_SELF_TURN, 1)
    end
    Duel.RegisterEffect(e1, tp)
end

-- 自肃过滤：限制不是鸟兽族且非暗属性的怪兽特殊召唤
function s.splimit(e, c, sump, sumtype, sumpos, targetp, se)
    return not (c:IsRace(RACE_WINDBEAST) and c:IsAttribute(ATTRIBUTE_DARK))
end

-- 场上表侧黑之森怪兽
function s.forest_filter(c)
    return c:IsFaceup() and c:IsSetCard(0x5aa) and c:IsType(TYPE_MONSTER)
end

-- 可送去墓地的黑之森怪兽
function s.gravefilter(c)
    return c:IsSetCard(0x5aa) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end

-- 效果② 条件：终末鸟特殊召唤成功
function s.retcon(e, tp, eg, ep, ev, re, r, rp)
    return eg:IsExists(Card.IsCode, 1, nil, 89222991)
end

-- 效果② 目标：自身回手
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
