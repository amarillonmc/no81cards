-- 和平
local s, id = GetID()
if not id then id = 89222999 end

function s.initial_effect(c)
    -- 规则上也当作「黑之森」卡使用
    local e0 = Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
    e0:SetCode(EFFECT_ADD_SETCODE)
    e0:SetValue(0x5aa)
    c:RegisterEffect(e0)

    -- 连接召唤：鸟兽族怪兽2只以上
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c, aux.FilterBoolFunction(Card.IsRace, RACE_WINDBEAST), 2, 99)

    -- 添加计数器：监控对方是否发动了手卡/墓地的怪兽效果
    Duel.AddCustomActivityCounter(id, ACTIVITY_CHAIN, s.chainfilter)

    -- 效果①：对方发动效果时，送墓1张永续魔法·陷阱，无效并破坏
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id, 0))
    e1:SetCategory(CATEGORY_DISABLE + CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_CHAINING)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1, id)                     -- ①效果1回合1次
    e1:SetCondition(s.negcon)
    e1:SetCost(s.negcost)
    e1:SetTarget(s.negtg)
    e1:SetOperation(s.negop)
    c:RegisterEffect(e1)

    -- 效果②：对方手卡/墓地怪兽效果发动的回合，自己鸟兽族·暗属性怪兽攻击力上升1000
    local e2 = Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(LOCATION_MZONE, 0)
    e2:SetTarget(s.atktg)
    e2:SetValue(s.atkval)
    c:RegisterEffect(e2)

    -- 效果③：这张卡被送去墓地，且自己场上没有装备魔法卡时，自己场上怪兽全部破坏
    local e3 = Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id, 1))
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_F)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetCondition(s.descon)
    e3:SetOperation(s.desop)
    c:RegisterEffect(e3)
end

-- 计数器过滤：记录对方是否发动了手卡/墓地的怪兽效果
function s.chainfilter(re, tp, cid)
    local loc = Duel.GetChainInfo(cid, CHAININFO_TRIGGERING_LOCATION)
    return not (re:IsActiveType(TYPE_MONSTER) and (bit.band(loc, LOCATION_HAND + LOCATION_GRAVE) ~= 0))
end

-- 效果①条件：自己场上有终末鸟，且对方发动效果
function s.negcon(e, tp, eg, ep, ev, re, r, rp)
    if rp ~= 1 - tp then return false end
    if not Duel.IsExistingMatchingCard(Card.IsCode, tp, LOCATION_MZONE, 0, 1, nil, 89222991) then
        return false
    end
    return Duel.IsChainNegatable(ev)
end

-- 效果①cost：把自己场上1张永续魔法·陷阱送去墓地
function s.costfilter(c)
    return c:IsType(TYPE_SPELL + TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) and c:IsAbleToGraveAsCost()
end

function s.negcost(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.IsExistingMatchingCard(s.costfilter, tp, LOCATION_SZONE, 0, 1, nil)
    end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOGRAVE)
    local g = Duel.SelectMatchingCard(tp, s.costfilter, tp, LOCATION_SZONE, 0, 1, 1, nil)
    Duel.SendtoGrave(g, REASON_COST)
end

function s.negtg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return true end
    Duel.SetOperationInfo(0, CATEGORY_DISABLE, eg, 1, 0, 0)
    if re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0, CATEGORY_DESTROY, eg, 1, 0, 0)
    end
end

function s.negop(e, tp, eg, ep, ev, re, r, rp)
    if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
        Duel.Destroy(eg, REASON_EFFECT)
    end
end

-- 效果②目标：鸟兽族·暗属性怪兽
function s.atktg(e, c)
    return c:IsRace(RACE_WINDBEAST) and c:IsAttribute(ATTRIBUTE_DARK)
end

-- 效果②攻击力增加值：如果对方在本回合发动过手卡/墓地的怪兽效果，则上升1000，否则0
function s.atkval(e, c)
    local tp = e:GetHandlerPlayer()
    if Duel.GetCustomActivityCount(id, 1 - tp, ACTIVITY_CHAIN) > 0 then
        return 1000
    else
        return 0
    end
end

-- 效果③条件：自己场上不存在装备魔法卡
function s.descon(e, tp, eg, ep, ev, re, r, rp)
    return not Duel.IsExistingMatchingCard(Card.IsType, tp, LOCATION_SZONE, 0, 1, nil, TYPE_EQUIP)
end

-- 效果③操作：破坏自己场上所有怪兽
function s.desop(e, tp, eg, ep, ev, re, r, rp)
    local g = Duel.GetMatchingGroup(Card.IsType, tp, LOCATION_MZONE, 0, nil, TYPE_MONSTER)
    if #g > 0 then
        Duel.Destroy(g, REASON_EFFECT)
    end
end