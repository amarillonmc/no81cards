-- 长臂
local s, id = GetID()
if not id then id = 89222997 end

function s.initial_effect(c)
    -- 在规则上也当作「黑之森」卡使用
    aux.AddCodeList(c, id)
    local etype = Effect.CreateEffect(c)
    etype:SetType(EFFECT_TYPE_SINGLE)
    etype:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    etype:SetCode(EFFECT_ADD_SETCODE)
    etype:SetValue(0x5aa) -- 黑之森字段
    c:RegisterEffect(etype)
    
    -- ④：「长臂」在自己场上只能有1张表侧表示存在
    c:SetUniqueOnField(1, 0, id, LOCATION_SZONE)
    
    -- 装备魔法激活
    local e1 = Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET + EFFECT_FLAG_CONTINUOUS_TARGET)
    e1:SetTarget(s.target)
    e1:SetOperation(s.operation)
    c:RegisterEffect(e1)
    
    -- ③：只能装备在「黑之森 终末与天启之鸟」上
    local e2 = Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_EQUIP_LIMIT)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetValue(s.eqlimit)
    c:RegisterEffect(e2)
    
    -- ①：装备中解放，从卡组特召「黑之森 高鸟」并给予效果
    local e3 = Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id, 0))
    e3:SetCategory(CATEGORY_RELEASE + CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCountLimit(1, id) -- 卡名1回合1次
    e3:SetCondition(s.relcon)
    e3:SetTarget(s.reltg)
    e3:SetOperation(s.relop)
    c:RegisterEffect(e3)
    
    -- ②：这张卡不能被除外
    local e4 = Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_SZONE)
    e4:SetCode(EFFECT_CANNOT_REMOVE)
    e4:SetValue(1)
    c:RegisterEffect(e4)
end

-- 装备目标选择
function s.eqfilter(c)
    return c:IsFaceup() and c:IsCode(89222991) -- 黑之森 终末与天启之鸟
end

function s.target(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.eqfilter(chkc) end
    if chk == 0 then return Duel.IsExistingTarget(s.eqfilter, tp, LOCATION_MZONE, 0, 1, nil) end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_EQUIP)
    local g = Duel.SelectTarget(tp, s.eqfilter, tp, LOCATION_MZONE, 0, 1, 1, nil)
    Duel.SetOperationInfo(0, CATEGORY_EQUIP, e:GetHandler(), 1, 0, 0)
end

function s.operation(e, tp, eg, ep, ev, re, r, rp)
    local tc = Duel.GetFirstTarget()
    if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
        Duel.Equip(tp, e:GetHandler(), tc)
    end
end

-- 装备限制：只能装备在指定怪兽上
function s.eqlimit(e, c)
    return c:IsCode(89222991) -- 黑之森 终末与天启之鸟
end

-- ①效果：装备中才能发动
function s.relcon(e)
    return e:GetHandler():GetEquipTarget() ~= nil
end

function s.spfilter(c, e, tp)
    return c:IsCode(89222981) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end

function s.reltg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
            and Duel.IsExistingMatchingCard(s.spfilter, tp, LOCATION_DECK, 0, 1, nil, e, tp)
    end
    Duel.SetOperationInfo(0, CATEGORY_RELEASE, e:GetHandler(), 1, 0, 0)
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_DECK)
end

function s.relop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    
    -- 解放自身
    if Duel.Release(c, REASON_EFFECT) == 0 then return end
    
    -- 从卡组特殊召唤「黑之森 高鸟」
    if Duel.GetLocationCount(tp, LOCATION_MZONE) <= 0 then return end
    
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
    local g = Duel.SelectMatchingCard(tp, s.spfilter, tp, LOCATION_DECK, 0, 1, 1, nil, e, tp)
    local tc = g:GetFirst()
    
    if tc and Duel.SpecialSummon(tc, 0, tp, tp, false, false, POS_FACEUP) > 0 then
        -- 给予额外效果：1回合1次，从卡组盖放「黑之森」魔法·陷阱卡
        local e1 = Effect.CreateEffect(c)
        e1:SetDescription(aux.Stringid(id, 1))
        e1:SetCategory(CATEGORY_LEAVE_DECK)
        e1:SetType(EFFECT_TYPE_IGNITION)
        e1:SetRange(LOCATION_MZONE)
        e1:SetCountLimit(1)
        e1:SetTarget(s.settg)
        e1:SetOperation(s.setop)
        e1:SetReset(RESET_EVENT + RESETS_STANDARD)
        tc:RegisterEffect(e1)
    end
end

-- 给予效果的盖放目标
function s.setfilter(c)
    return c:IsSetCard(0x5aa) and c:IsType(TYPE_SPELL + TYPE_TRAP) and not c:IsForbidden()
end

function s.settg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.GetLocationCount(tp, LOCATION_SZONE) > 0
            and Duel.IsExistingMatchingCard(s.setfilter, tp, LOCATION_DECK, 0, 1, nil)
    end
    Duel.SetOperationInfo(0, CATEGORY_LEAVE_DECK, nil, 1, tp, 0)
end

function s.setop(e, tp, eg, ep, ev, re, r, rp)
    if Duel.GetLocationCount(tp, LOCATION_SZONE) <= 0 then return end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SET)
    local g = Duel.SelectMatchingCard(tp, s.setfilter, tp, LOCATION_DECK, 0, 1, 1, nil)
    local tc = g:GetFirst()
    if tc then
        Duel.SSet(tp, tc)
    end
end