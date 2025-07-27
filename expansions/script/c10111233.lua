-- 卡片ID定义
CARD_MYSTERIOUS_HAND = 10111233 -- 自定义卡号
CARD_MAGIC_HAND = 22530212
CARD_FIRE_HAND = 68535320
CARD_ICE_HAND = 95929069

-- 卡片注册
local s, id = GetID()
function s.initial_effect(c)
    -- 效果1：对方发动怪兽效果时特殊召唤
    local e1 = Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_CHAINING)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(s.spcon)
    e1:SetTarget(s.sptg)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)
    
    -- 效果2：改变魔法/陷阱效果
    local e2 = Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_NO_TURN_RESET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCondition(s.efcon)
    e2:SetOperation(s.efop)
    c:RegisterEffect(e2)
end

-- 效果1条件：对方发动怪兽效果
function s.spcon(e, tp, eg, ep, ev, re, r, rp)
    return rp == 1-tp and re:IsActiveType(TYPE_MONSTER)
end

-- 效果1目标：选择手牌/墓地的"手"系列怪兽
function s.spfilter(c,e,tp)
    return c:IsCode(CARD_MAGIC_HAND, CARD_FIRE_HAND, CARD_ICE_HAND) and 
        (c:IsLocation(LOCATION_HAND) or (c:IsLocation(LOCATION_GRAVE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end

function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
    local c = e:GetHandler()
    if chk == 0 then 
        return not Duel.IsPlayerAffectedByEffect(tp, 59822133)  -- 英豪冠军限制
            and Duel.GetLocationCount(tp, LOCATION_MZONE) > 1
            and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
            and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.spfilter), tp, LOCATION_HAND|LOCATION_GRAVE, 0, 1, c, e, tp)
    end
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 2, tp, LOCATION_HAND|LOCATION_GRAVE)
end

-- 效果1操作：特殊召唤
function s.spop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if Duel.IsPlayerAffectedByEffect(tp, 59822133) 
        or Duel.GetLocationCount(tp, LOCATION_MZONE) < 2 
        or not c:IsRelateToEffect(e) 
        or not c:IsCanBeSpecialSummoned(e, 0, tp, false, false) 
    then 
        return 
    end
    
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
    local g = Duel.SelectMatchingCard(tp, aux.NecroValleyFilter(s.spfilter), tp, LOCATION_HAND|LOCATION_GRAVE, 0, 1, 1, c, e, tp)
    if #g == 0 then return end
    g:AddCard(c)
    
    -- 特殊召唤
    local tc = g:GetFirst()
    while tc do
        Duel.SpecialSummonStep(tc, 0, tp, tp, false, false, POS_FACEUP)
        tc = g:GetNext()
    end
    Duel.SpecialSummonComplete()
    
    -- 添加限制效果
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1, 0)
    e1:SetTarget(s.splimit)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1, tp)
end

-- 效果2条件：对方发动魔法/陷阱
function s.efcon(e, tp, eg, ep, ev, re, r, rp)
    return rp == 1-tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end

-- 效果2操作：改变效果
function s.efop(e, tp, eg, ep, ev, re, r, rp)
    -- 添加限制效果
    local e1 = Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1, 0)
    e1:SetTarget(s.splimit)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1, tp)
    
    -- 保存原效果信息
    local oldop = re:GetOperation()
    local oldtarget = re:GetTarget()
    local oldvalue = re:GetValue()
    
    -- 覆盖魔法/陷阱效果
    local newop = function(e, tp, eg, ep, ev, re, r, rp)
        Duel.Hint(HINT_CARD, 0, id)
        Duel.Hint(HINT_SELECTMSG, 1-tp, HINTMSG_DESTROY)
        local g = Duel.SelectMatchingCard(1-tp, Card.IsFaceup, 1-tp, LOCATION_MZONE, 0, 1, 1, nil)
        if #g > 0 then
            Duel.Destroy(g, REASON_EFFECT)
        end
    end
    
    -- 设置新效果
    re:SetOperation(newop)
    
    -- 创建重置效果
    local reset = Effect.CreateEffect(e:GetHandler())
    reset:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    reset:SetCode(EVENT_CHAIN_SOLVED)
    reset:SetLabelObject(re)
    reset:SetLabel(0)
    reset:SetCondition(s.resetcon)
    reset:SetOperation(function(e)
        local re=e:GetLabelObject()
        if re then
            re:SetOperation(oldop)
            re:SetTarget(oldtarget)
            re:SetValue(oldvalue)
        end
        e:Reset()
    end)
    reset:SetReset(RESET_CHAIN)
    Duel.RegisterEffect(reset, tp)
end

-- 重置条件
function s.resetcon(e, tp, eg, ep, ev, re, r, rp)
    return re == e:GetLabelObject()
end

-- 重置操作
function s.resetop(e, tp, eg, ep, ev, re, r, rp)
    re:SetOperation(e:GetLabel())
end

-- 限制效果：只能特殊召唤岩石族超量怪兽
function s.splimit(e, c)
    return c:IsLocation(LOCATION_EXTRA) and not (c:IsRace(RACE_ROCK) and c:IsType(TYPE_XYZ))
end