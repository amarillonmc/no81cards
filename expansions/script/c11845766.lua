-- 数契尖兵 阿尔法之座
local s,id,o= GetID()
function s.initial_effect(c)
    -- 融合召唤
    c:EnableReviveLimit()
    aux.AddFusionProcFunFunRep(c,s.ffilter,aux.FilterBoolFunction(Card.IsRace,RACE_CYBERSE),2,2,true,true,s.fcheck)
    -- 效果①：融合召唤   
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id, 0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON + CATEGORY_FUSION_SUMMON)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,id)
    e1:SetCondition(s.fuscon)
    e1:SetTarget(s.fustg)
    e1:SetOperation(s.fusop)
    c:RegisterEffect(e1)

    -- 效果②：额外攻击
    local e2 = Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_EXTRA_ATTACK)
    e2:SetValue(s.atkval)
    c:RegisterEffect(e2)

    -- 
    local e3 = Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_DRAW)
    e3:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCountLimit(1,id+o)
    e3:SetCondition(s.drcon)
    e3:SetTarget(s.drtg)
    e3:SetOperation(s.drop)
    c:RegisterEffect(e3)
end
function s.ffilter(c)
	return c:IsSetCard(0xf80) and c:IsType(TYPE_MONSTER)
end    
--融合素材筛选器
function s.fcheck(g,lc)
	return g:IsExists(Card.IsFusionType,3,nil,(TYPE_MONSTER))
end  


-- 效果①条件
function s.fuscon(e, tp, eg, ep, ev, re, r, rp)
    return true
end

-- 效果①目标
function s.fusfilter(c, e, tp, m, f, chkf)
    return c:IsType(TYPE_FUSION) 
        and c:IsCanBeSpecialSummoned(e, SUMMON_TYPE_FUSION, tp, false, false)
        and c:CheckFusionMaterial(m, nil, chkf)
end
function s.fustg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        local chkf = tp
        local mg1 = Duel.GetMatchingGroup(Card.IsAbleToRemove, tp, LOCATION_HAND + LOCATION_MZONE + LOCATION_GRAVE, 0, nil)
        local res = Duel.IsExistingMatchingCard(s.fusfilter, tp, LOCATION_EXTRA, 0, 1, nil, e, tp, mg1, nil, chkf)
        if not res then
            local ce = Duel.GetChainMaterial(tp)
            if ce ~= nil then
                local fgroup = ce:GetTarget()
                local mg2 = fgroup(ce, e, tp)
                local mf = ce:GetValue()
                res = Duel.IsExistingMatchingCard(s.fusfilter, tp, LOCATION_EXTRA, 0, 1, nil, e, tp, mg2, mf, chkf)
            end
        end
        return res
    end
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_EXTRA)
end

-- 效果①操作
function s.fusop(e, tp, eg, ep, ev, re, r, rp)
    local chkf = tp
    local mg1 = Duel.GetMatchingGroup(Card.IsAbleToRemove, tp, LOCATION_HAND + LOCATION_MZONE + LOCATION_GRAVE, 0, nil)
    local sg1 = Duel.GetMatchingGroup(s.fusfilter, tp, LOCATION_EXTRA, 0, nil, e, tp, mg1, nil, chkf)
    local mg2 = nil
    local sg2 = nil
    local ce = Duel.GetChainMaterial(tp)
    if ce ~= nil then
        local fgroup = ce:GetTarget()
        mg2 = fgroup(ce, e, tp)
        local mf = ce:GetValue()
        sg2 = Duel.GetMatchingGroup(s.fusfilter, tp, LOCATION_EXTRA, 0, nil, e, tp, mg2, mf, chkf)
    end
    if sg1:GetCount() > 0 or (sg2 ~= nil and sg2:GetCount() > 0) then
        local sg = sg1:Clone()
        if sg2 then sg:Merge(sg2) end
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
        local tg = sg:Select(tp, 1, 1, nil)
        local tc = tg:GetFirst()
        local mat = nil
        if sg1:IsContains(tc) and (sg2 == nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp, ce:GetDescription())) then
            mat = Duel.SelectFusionMaterial(tp, tc, mg1, nil, chkf)
            Duel.Remove(mat, POS_FACEUP, REASON_EFFECT + REASON_MATERIAL + REASON_FUSION)
        else
            mat = Duel.SelectFusionMaterial(tp, tc, mg2, nil, chkf)
            local fop = ce:GetOperation()
            fop(ce, e, tp, tc, mat)
        end
        Duel.BreakEffect()
        Duel.SpecialSummon(tc, SUMMON_TYPE_FUSION, tp, tp, false, false, POS_FACEUP)
        tc:CompleteProcedure()
    end
end

-- 效果②额外攻击数量
function s.atkval(e,c)
    return Duel.GetMatchingGroupCount(Card.IsType,c:GetControler(),LOCATION_MZONE,0,nil,TYPE_FUSION)-1  -- 排除自身
end
-- 效果③条件
function s.drcon(e, tp, eg, ep, ev, re, r, rp)
    return true
end

-- 效果③目标
function s.drtg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return Duel.IsPlayerCanDraw(tp, 1) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0, CATEGORY_DRAW, nil, 0, tp, 1)
end

-- 效果③操作
function s.drop(e, tp, eg, ep, ev, re, r, rp)
    local p, d = Duel.GetChainInfo(0, CHAININFO_TARGET_PLAYER, CHAININFO_TARGET_PARAM)
    Duel.Draw(p, d, REASON_EFFECT)
end