-- 黑之森之门
local s, id = GetID()
if not id then id = 89222988 end

function s.initial_effect(c)
    -- 永续魔法
    c:SetSPSummonOnce(id)
    
    local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
    -- ①：从卡组特召「黑之森」怪兽
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id, 0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_SZONE)
    e1:SetCountLimit(1,id) -- ①效果一回合一次
    e1:SetTarget(s.sptg)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)
    
    -- ②：融合召唤「黑之森」融合怪兽 (无自肃)
    local e2 = Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id, 1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON + CATEGORY_FUSION_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCountLimit(1,id+100) -- ②效果一回合一次
    e2:SetTarget(s.fusiontg)
    e2:SetOperation(s.fusionop)
    c:RegisterEffect(e2)
    
    -- ③：送墓时从卡组送墓「黑之森」魔法·陷阱
    local e3 = Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id, 2))
    e3:SetCategory(CATEGORY_TOGRAVE)
    e3:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetCountLimit(1,id+200) -- ③效果一回合一次
    e3:SetCondition(s.tgcon)
    e3:SetTarget(s.tgtg)
    e3:SetOperation(s.tgop)
    c:RegisterEffect(e3)
end

-- 效果①：从卡组特召「黑之森」怪兽
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
    if not e:GetHandler():IsRelateToEffect(e) or Duel.GetLocationCount(tp, LOCATION_MZONE) <= 0 then return end
    
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
    local g = Duel.SelectMatchingCard(tp, s.spfilter, tp, LOCATION_DECK, 0, 1, 1, nil, e, tp)
    
    if #g > 0 and Duel.SpecialSummon(g, 0, tp, tp, false, false, POS_FACEUP) > 0 then
        -- 【仅保留效果①的自肃】：直到回合结束时，自己不是鸟兽族·暗属性怪兽不能特殊召唤
        local e1 = Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
        e1:SetTargetRange(1, 0)
        e1:SetTarget(s.splimit)
        e1:SetReset(RESET_PHASE + PHASE_END)
        Duel.RegisterEffect(e1, tp)
    end
end

-- 效果①的自肃限制函数
function s.splimit(e, c)
    return not (c:IsRace(RACE_WINDBEAST) and c:IsAttribute(ATTRIBUTE_DARK))
end

-- 效果②：融合召唤「黑之森」融合怪兽 (参考“烙印融合”机制，无自肃)
function s.filter0(c, e)
    return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToDeck() and not c:IsImmuneToEffect(e)
end

function s.filter1(c, e, tp, mg, f, chkf)
    if not (c:IsType(TYPE_FUSION) and c:IsSetCard(0x5aa) and (not f or f(c))
        and c:IsCanBeSpecialSummoned(e, SUMMON_TYPE_FUSION, tp, false, false)) then return false end
    return c:CheckFusionMaterial(mg, nil, chkf)
end

function s.fusiontg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        local chkf = tp
        local mg = Duel.GetMatchingGroup(s.filter0, tp, LOCATION_MZONE + LOCATION_GRAVE + LOCATION_REMOVED, 0, nil, e)
        local res = Duel.IsExistingMatchingCard(s.filter1, tp, LOCATION_EXTRA, 0, 1, nil, e, tp, mg, nil, chkf)
        if not res then
            local ce = Duel.GetChainMaterial(tp)
            if ce ~= nil then
                local fgroup = ce:GetTarget()
                local mg2 = fgroup(ce, e, tp)
                local mf = ce:GetValue()
                res = Duel.IsExistingMatchingCard(s.filter1, tp, LOCATION_EXTRA, 0, 1, nil, e, tp, mg2, mf, chkf)
            end
        end
        return res
    end
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_EXTRA)
end

function s.fusionop(e, tp, eg, ep, ev, re, r, rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    
    local chkf = tp
    local mg = Duel.GetMatchingGroup(aux.NecroValleyFilter(s.filter0), tp, LOCATION_MZONE + LOCATION_GRAVE + LOCATION_REMOVED, 0, nil, e)
    local sg1 = Duel.GetMatchingGroup(s.filter1, tp, LOCATION_EXTRA, 0, nil, e, tp, mg, nil, chkf)
    local mg2, sg2 = nil, nil
    local ce = Duel.GetChainMaterial(tp)
    if ce ~= nil then
        local fgroup = ce:GetTarget()
        mg2 = fgroup(ce, e, tp)
        local mf = ce:GetValue()
        sg2 = Duel.GetMatchingGroup(s.filter1, tp, LOCATION_EXTRA, 0, nil, e, tp, mg2, mf, chkf)
    end
    
    if sg1:GetCount() > 0 or (sg2 ~= nil and sg2:GetCount() > 0) then
        local sg = sg1:Clone()
        if sg2 then sg:Merge(sg2) end
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
        local tg = sg:Select(tp, 1, 1, nil)
        local tc = tg:GetFirst()
        if sg1:IsContains(tc) and (sg2 == nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp, ce and ce:GetDescription() or 0)) then
            local mat1 = Duel.SelectFusionMaterial(tp, tc, mg, nil, chkf)
            tc:SetMaterial(mat1)
            -- 素材返回卡组
            Duel.SendtoDeck(mat1, nil, SEQ_DECKSHUFFLE, REASON_EFFECT + REASON_MATERIAL + REASON_FUSION)
            Duel.BreakEffect()
            Duel.SpecialSummon(tc, SUMMON_TYPE_FUSION, tp, tp, false, false, POS_FACEUP)
            tc:CompleteProcedure()
        elseif ce ~= nil then
            local mat2 = Duel.SelectFusionMaterial(tp, tc, mg2, nil, chkf)
            local fop = ce:GetOperation()
            fop(ce, e, tp, tc, mat2)
        end
    end
end

-- 效果③：送墓时从卡组送墓「黑之森」魔法·陷阱
-- 效果③：送墓时从卡组送墓「黑之森」魔法·陷阱
function s.tgfilter(c)
    return c:IsSetCard(0x5aa) and c:IsType(TYPE_SPELL + TYPE_TRAP) and c:IsAbleToGrave()
end

-- 修正发动条件：只要这张卡被送去墓地即可，无论原因（包括作为cost）
function s.tgcon(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    -- 检查卡是否在墓地，并且是刚从其他位置送去的
    return c:IsLocation(LOCATION_GRAVE) and c:IsPreviousLocation(LOCATION_ONFIELD+LOCATION_HAND+LOCATION_DECK)
end

function s.tgtg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.IsExistingMatchingCard(s.tgfilter, tp, LOCATION_DECK, 0, 1, nil)
    end
    Duel.SetOperationInfo(0, CATEGORY_TOGRAVE, nil, 1, tp, LOCATION_DECK)
end

function s.tgop(e, tp, eg, ep, ev, re, r, rp)
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOGRAVE)
    local g = Duel.SelectMatchingCard(tp, s.tgfilter, tp, LOCATION_DECK, 0, 1, 1, nil)
    if #g > 0 then
        Duel.SendtoGrave(g, REASON_EFFECT)
    end
end