-- 巨目
local s, id = GetID()
if not id then id = 89222996 end

function s.initial_effect(c)
    -- 在规则上也当作「黑之森」卡使用
    local etype=Effect.CreateEffect(c)
    etype:SetType(EFFECT_TYPE_SINGLE)
    etype:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    etype:SetCode(EFFECT_ADD_SETCODE)
    etype:SetValue(0x5aa) -- 黑之森字段
    c:RegisterEffect(etype)
    
    -- ④：「巨目」在自己场上只能有1张表侧表示存在
    c:SetUniqueOnField(1, 0, id)
    
    -- 装备魔法激活
    local e1 = Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET + EFFECT_FLAG_CONTINUOUS_TARGET)
    e1:SetTarget(s.eqtg)
    e1:SetOperation(s.eqop)
    c:RegisterEffect(e1)
    
    -- ②：对方不能把场上的这张卡作为效果的对象
    local e2 = Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e2:SetCondition(s.tgcon)
    e2:SetValue(aux.tgoval)
    c:RegisterEffect(e2)
    
    -- ③：装备限制
    local e3 = Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_EQUIP_LIMIT)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e3:SetValue(s.eqlimit)
    c:RegisterEffect(e3)
    
    -- ①：解放自身并特召「黑之森 大鸟」
    local e4 = Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id, 0))
    e4:SetCategory(CATEGORY_RELEASE + CATEGORY_SPECIAL_SUMMON + CATEGORY_DRAW)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_SZONE)
    e4:SetCountLimit(1, id) -- ①效果1回合只能使用1次
    e4:SetCondition(s.rlcon)
    e4:SetTarget(s.rltg)
    e4:SetOperation(s.rlop)
    c:RegisterEffect(e4)
end

-- 装备目标：只能装备在「黑之森 终末与天启之鸟」上
function s.eqfilter(c)
    return c:IsFaceup() and c:IsCode(89222991) 
end

function s.eqtg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.eqfilter(chkc) end
    if chk == 0 then return Duel.IsExistingTarget(s.eqfilter, tp, LOCATION_MZONE, 0, 1, nil) end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_EQUIP)
    local g = Duel.SelectTarget(tp, s.eqfilter, tp, LOCATION_MZONE, 0, 1, 1, nil)
    Duel.SetOperationInfo(0, CATEGORY_EQUIP, e:GetHandler(), 1, 0, 0)
end

function s.eqop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    local tc = Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
        Duel.Equip(tp, c, tc)
    end
end

-- ③：装备限制函数
function s.eqlimit(e, c)
    return c:IsCode(89222991) -- 只能装备在「黑之森 终末与天启之鸟」上
end

-- ②：不能成为效果对象的条件
function s.tgcon(e)
    return e:GetHandler():IsFaceup()
end

-- ①：解放自身的条件：装备中
function s.rlcon(e, tp, eg, ep, ev, re, r, rp)
    return e:GetHandler():GetEquipTarget() ~= nil
end

-- ①：解放自身并特召「黑之森 大鸟」
function s.spfilter(c, e, tp)
    return c:IsCode(89222980) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false) 
end

function s.rltg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
            and Duel.IsExistingMatchingCard(s.spfilter, tp, LOCATION_DECK, 0, 1, nil, e, tp)
    end
    Duel.SetOperationInfo(0, CATEGORY_RELEASE, e:GetHandler(), 1, 0, 0)
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_DECK)
end

function s.rlop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if not c:IsRelateToEffect(e) or not c:GetEquipTarget() then return end
    
    -- 解放此卡
    if Duel.Release(c, REASON_EFFECT) > 0 then
        if Duel.GetLocationCount(tp, LOCATION_MZONE) <= 0 then return end
        
        -- 从卡组特殊召唤「黑之森 大鸟」
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
        local g = Duel.SelectMatchingCard(tp, s.spfilter, tp, LOCATION_DECK, 0, 1, 1, nil, e, tp)
        local tc = g:GetFirst()
        if tc and Duel.SpecialSummonStep(tc, 0, tp, tp, false, false, POS_FACEUP) then
            -- 给予抽卡效果
            local e1 = Effect.CreateEffect(c)
            e1:SetDescription(aux.Stringid(id, 1))
            e1:SetCategory(CATEGORY_DRAW)
            e1:SetType(EFFECT_TYPE_IGNITION)
            e1:SetRange(LOCATION_MZONE)
            e1:SetCountLimit(1)
            e1:SetTarget(s.drtg)
            e1:SetOperation(s.drop)
            e1:SetReset(RESET_EVENT + RESETS_STANDARD)
            tc:RegisterEffect(e1, true)
            
            Duel.SpecialSummonComplete()
        end
    end
end

-- 「黑之森 大鸟」获得的抽卡效果
function s.drtg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return Duel.IsPlayerCanDraw(tp, 1) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0, CATEGORY_DRAW, nil, 0, tp, 1)
end

function s.drop(e, tp, eg, ep, ev, re, r, rp)
    local p, d = Duel.GetChainInfo(0, CHAININFO_TARGET_PLAYER, CHAININFO_TARGET_PARAM)
    Duel.Draw(p, d, REASON_EFFECT)
end