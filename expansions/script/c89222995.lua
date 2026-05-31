-- "小喙"
local s, id = GetID()
if not id then id = 89222995 end

function s.initial_effect(c)
    -- 在规则上也当作「黑之森」卡使用 (注：0x5aa 为你自定义的字段)
    local etype = Effect.CreateEffect(c)
    etype:SetType(EFFECT_TYPE_SINGLE)
    etype:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
    etype:SetCode(EFFECT_ADD_SETCODE)
    etype:SetValue(0x5aa) 
    c:RegisterEffect(etype)
    
    -- ①：自己场上只能有1张表侧表示存在
    c:SetUniqueOnField(1, 0, id)
    
    -- ②：装备魔法激活
    local e1 = Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET + EFFECT_FLAG_CONTINUOUS_TARGET)
    e1:SetTarget(s.target)
    e1:SetOperation(s.operation)
    c:RegisterEffect(e1)
    
    -- ③：装备限制（仅限「黑之森 终末与天启之鸟」）
    local e2 = Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_EQUIP_LIMIT)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetValue(s.eqlimit)
    c:RegisterEffect(e2)
    
    -- ④：解放自身特召并赋予效果 (1回合1次)
    local e3 = Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id, 0))
    e3:SetCategory(CATEGORY_RELEASE + CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCountLimit(1, id)
    e3:SetCondition(s.spcon)
    e3:SetTarget(s.sptg)
    e3:SetOperation(s.spop)
    c:RegisterEffect(e3)
    
    -- ⑤：在魔陷区时不会被效果破坏
    local e4 = Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_SZONE)
    e4:SetValue(1)
    c:RegisterEffect(e4)
end

-- --- 辅助过滤函数 ---
function s.eqfilter(c)
    return c:IsFaceup() and c:IsCode(89222991) -- 「黑之森 终末与天启之鸟」
end

-- --- 装备逻辑 ---
function s.eqlimit(e, c)
    return c:IsCode(89222991)
end

function s.target(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.eqfilter(chkc) end
    if chk == 0 then return Duel.IsExistingTarget(s.eqfilter, tp, LOCATION_MZONE, LOCATION_MZONE, 1, nil) end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_EQUIP)
    Duel.SelectTarget(tp, s.eqfilter, tp, LOCATION_MZONE, LOCATION_MZONE, 1, 1, nil)
    Duel.SetOperationInfo(0, CATEGORY_EQUIP, e:GetHandler(), 1, 0, 0)
end

function s.operation(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    local tc = Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
        Duel.Equip(tp, c, tc)
    end
end

-- --- 特召逻辑 ---
function s.spcon(e, tp, eg, ep, ev, re, r, rp)
    return e:GetHandler():GetEquipTarget() ~= nil
end

function s.spfilter(c, e, tp)
    return c:IsCode(89222982) -- 「黑之森 小鸟」
        and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end

function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        -- 注意：解放自身会腾出一个格子，但此时仍需检查卡组是否有怪
        return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
            and Duel.IsExistingMatchingCard(s.spfilter, tp, LOCATION_DECK, 0, 1, nil, e, tp)
    end
    Duel.SetOperationInfo(0, CATEGORY_RELEASE, e:GetHandler(), 1, 0, 0)
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_DECK)
end

function s.spop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    
    -- 执行解放并特召
    if Duel.Release(c, REASON_EFFECT) > 0 then
        if Duel.GetLocationCount(tp, LOCATION_MZONE) <= 0 then return end
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
        local g = Duel.SelectMatchingCard(tp, s.spfilter, tp, LOCATION_DECK, 0, 1, 1, nil, e, tp)
        local tc = g:GetFirst()
        if tc and Duel.SpecialSummon(tc, 0, tp, tp, false, false, POS_FACEUP) > 0 then
            -- 赋予效果：1回合1次，选场上1张卡破坏
            local e1 = Effect.CreateEffect(c)
            e1:SetDescription(aux.Stringid(id, 1))
            e1:SetCategory(CATEGORY_DESTROY)
            e1:SetType(EFFECT_TYPE_IGNITION)
            e1:SetRange(LOCATION_MZONE)
            e1:SetCountLimit(1)
            e1:SetProperty(EFFECT_FLAG_CARD_TARGET) -- 建议加上选取对象属性
            e1:SetTarget(s.destg)
            e1:SetOperation(s.desop)
            e1:SetReset(RESET_EVENT + RESETS_STANDARD)
            tc:RegisterEffect(e1, true)
        end
    end
end

-- --- 赋予的破坏效果逻辑 ---
function s.destg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
    if chkc then return chkc:IsOnField() end
    if chk == 0 then return Duel.IsExistingTarget(nil, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, 1, nil) end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DESTROY)
    local g = Duel.SelectTarget(tp, nil, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, 1, 1, nil)
    Duel.SetOperationInfo(0, CATEGORY_DESTROY, g, 1, 0, 0)
end

function s.desop(e, tp, eg, ep, ev, re, r, rp)
    local tc = Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then
        Duel.Destroy(tc, REASON_EFFECT)
    end
end