-- 黑之森融合怪兽 (卡密89222991)
local s, id = GetID()
if not id then id = 89222991 end

function s.initial_effect(c)
    -- 融合怪兽
    c:EnableReviveLimit()
    -- 融合素材：黑之森大鸟+黑之森高鸟+黑之森小鸟
    aux.AddFusionProcCode3(c, 89222980, 89222981, 89222982, true, true)
    
    -- ①：融合召唤时装备装备魔法 (修正：添加区域空位检查)
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id, 0))
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCountLimit(1, id)
    e1:SetCondition(s.eqcon)
    e1:SetTarget(s.eqtg)
    e1:SetOperation(s.eqop)
    c:RegisterEffect(e1)
    
    -- ②：装备时免疫非黑之森卡效果
    local e2 = Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EFFECT_IMMUNE_EFFECT)
    e2:SetCondition(s.immcon)
    e2:SetValue(s.immval)
    c:RegisterEffect(e2)
    
    -- ③：对方把效果发动时才能发动（诱发即时效果）
    local e3 = Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id, 1))
    e3:SetCategory(CATEGORY_REMOVE)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_CHAINING)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1, id + 100)
    e3:SetCondition(s.rmcon2)
    e3:SetTarget(s.rmtg)
    e3:SetOperation(s.rmop)
    c:RegisterEffect(e3)
    
    -- ④：墓地回收效果
    local e4 = Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id, 2))
    e4:SetCategory(CATEGORY_TOHAND + CATEGORY_TODECK)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_GRAVE)
    e4:SetCountLimit(1, id + 200)
    e4:SetCost(s.thcost)
    e4:SetTarget(s.thtg)
    e4:SetOperation(s.thop)
    c:RegisterEffect(e4)
end

-- ①：融合召唤条件
function s.eqcon(e, tp, eg, ep, ev, re, r, rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end

-- ①：装备魔法过滤
function s.eqfilter(c)
    return c:IsSetCard(0x5aa) and c:IsType(TYPE_EQUIP) and not c:IsForbidden()
end

function s.eqtg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        -- 检查魔法陷阱区域是否有至少3个空位
        if Duel.GetLocationCount(tp, LOCATION_SZONE) < 3 then return false end
        local g = Duel.GetMatchingGroup(s.eqfilter, tp, LOCATION_DECK + LOCATION_GRAVE, 0, nil)
        local names = {}
        for tc in aux.Next(g) do
            if not names[tc:GetCode()] then
                names[tc:GetCode()] = true
            end
        end
        local count = 0
        for _ in pairs(names) do
            count = count + 1
        end
        return count >= 3
    end
    Duel.SetOperationInfo(0, CATEGORY_EQUIP, nil, 3, tp, LOCATION_DECK + LOCATION_GRAVE)
    -- 关键：不能对应这个效果的发动让魔法·陷阱·怪兽的效果发动
    Duel.SetChainLimit(aux.FALSE)
end

function s.eqop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
    
    local g = Duel.GetMatchingGroup(s.eqfilter, tp, LOCATION_DECK + LOCATION_GRAVE, 0, nil)
    local selected = {}
    local names = {}
    
    for i = 1, 3 do
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_EQUIP)
        local sg = g:Filter(s.eqfilter2, nil, names)
        if #sg == 0 then break end
        
        local tc = sg:Select(tp, 1, 1, nil):GetFirst()
        selected[#selected + 1] = tc
        names[tc:GetCode()] = true
        g:RemoveCard(tc)
    end
    
    for _, tc in ipairs(selected) do
        if Duel.Equip(tp, tc, c, true) then
            local e1 = Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
            e1:SetCode(EFFECT_EQUIP_LIMIT)
            e1:SetReset(RESET_EVENT + RESETS_STANDARD)
            e1:SetValue(s.eqlimit)
            tc:RegisterEffect(e1)
        end
    end
end

function s.eqfilter2(c, names)
    return s.eqfilter(c) and not names[c:GetCode()]
end

function s.eqlimit(e, c)
    return e:GetOwner() == c
end

-- ②：免疫效果条件
function s.immcon(e)
    return e:GetHandler():GetEquipGroup():Filter(Card.IsSetCard, nil, 0x5aa):GetCount() > 0
end

function s.immval(e, te)
    return te:GetOwner() and not te:GetOwner():IsSetCard(0x5aa)
end

-- ③：对方把效果发动时的条件（诱发即时）
function s.rmcon2(e, tp, eg, ep, ev, re, r, rp)
    return ep == 1 - tp and re:IsActiveType(TYPE_MONSTER + TYPE_SPELL + TYPE_TRAP)
end

function s.rmtg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return Duel.GetFieldGroupCount(1 - tp, LOCATION_HAND, 0) > 0 end
    Duel.SetOperationInfo(0, CATEGORY_REMOVE, nil, 1, 1 - tp, LOCATION_HAND)
end

function s.rmop(e, tp, eg, ep, ev, re, r, rp)
    local g = Duel.GetFieldGroup(tp, 0, LOCATION_HAND)
    if #g == 0 then return end
    
    Duel.ConfirmCards(tp, g)
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_REMOVE)
    local sg = g:Select(tp, 1, 1, nil)
    local tc = sg:GetFirst()
    if tc then
        Duel.Remove(tc, POS_FACEUP, REASON_EFFECT)
        
        -- 直到结束阶段除外
        local e1 = Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
        e1:SetCode(EVENT_PHASE + PHASE_END)
        e1:SetCountLimit(1)
        e1:SetLabelObject(tc)
        e1:SetOperation(s.retop)
        e1:SetReset(RESET_PHASE + PHASE_END)
        Duel.RegisterEffect(e1, tp)
    end
    Duel.ShuffleHand(1 - tp)
end

function s.retop(e, tp, eg, ep, ev, re, r, rp)
    local tc = e:GetLabelObject()
    if tc then
        Duel.SendtoHand(tc, nil, REASON_EFFECT)
    end
end

-- ④：墓地回收效果
function s.thcost(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return e:GetHandler():IsAbleToExtraAsCost() end
    Duel.SendtoDeck(e:GetHandler(), nil, 0, REASON_COST)
end

function s.thfilter(c)
    return c:IsSetCard(0x5aa) and c:IsAbleToHand()
end

function s.thtg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
    if chk == 0 then return Duel.IsExistingMatchingCard(s.thfilter, tp, LOCATION_GRAVE, 0, 1, e:GetHandler()) end
    Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_GRAVE)
end

function s.thop(e, tp, eg, ep, ev, re, r, rp)
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
    local g = Duel.SelectMatchingCard(tp, s.thfilter, tp, LOCATION_GRAVE, 0, 1, 1, nil)
    if #g > 0 then
        Duel.SendtoHand(g, nil, REASON_EFFECT)
        Duel.ConfirmCards(1 - tp, g)
    end
end