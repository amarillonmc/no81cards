-- 数契约融合
local s, id, o = GetID()
function s.initial_effect(c)
    -- 融合效果
    local e3 = Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON + CATEGORY_FUSION_SUMMON)
    e3:SetType(EFFECT_TYPE_ACTIVATE)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetCountLimit(1, id, EFFECT_COUNT_CODE_OATH)
    e3:SetCost(s.cost)
    e3:SetTarget(s.target)
    e3:SetOperation(s.activate)
    c:RegisterEffect(e3)
    Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,s.counterfilter)
end
function s.counterfilter(c)
	return c:IsRace(RACE_CYBERSE)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(11845771,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	Duel.RegisterEffect(e1,tp)
end

function s.splimit(e, c)
    return  not c:IsSetCard(0xf80)
end


function s.filter1(c, e)
    return not c:IsImmuneToEffect(e)
end


function s.filter2(c, e, tp, m, f, chkf)
    return c:IsType(TYPE_FUSION) and c:IsRace(RACE_CYBERSE)
        and c:IsCanBeSpecialSummoned(e, SUMMON_TYPE_FUSION, tp, false, false)
        and c:CheckFusionMaterial(m, nil, chkf)
end


function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        local chkf = tp
        local mg1 = Duel.GetMatchingGroup(Card.IsAbleToGrave, tp, LOCATION_HAND + LOCATION_MZONE + LOCATION_EXTRA, 0, nil)
        local res = Duel.IsExistingMatchingCard(s.filter2, tp, LOCATION_EXTRA, 0, 1, nil, e, tp, mg1, nil, chkf)
        if not res then
            local ce = Duel.GetChainMaterial(tp)
            if ce ~= nil then
                local fgroup = ce:GetTarget()
                local mg2 = fgroup(ce, e, tp)
                local mf = ce:GetValue()
                res = Duel.IsExistingMatchingCard(s.filter2, tp, LOCATION_EXTRA, 0, 1, nil, e, tp, mg2, mf, chkf)
            end
        end
        return res
    end
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_EXTRA)
end

-- 融合效果操作
function s.activate(e, tp, eg, ep, ev, re, r, rp)
    local chkf = tp
    local mg1 = Duel.GetMatchingGroup(Card.IsAbleToGrave, tp, LOCATION_HAND + LOCATION_MZONE + LOCATION_EXTRA, 0, nil):Filter(s.filter1, nil, e)
    local sg1 = Duel.GetMatchingGroup(s.filter2, tp, LOCATION_EXTRA, 0, nil, e, tp, mg1, nil, chkf)
    local mg2 = nil
    local sg2 = nil
    local ce = Duel.GetChainMaterial(tp)
    if ce ~= nil then
        local fgroup = ce:GetTarget()
        mg2 = fgroup(ce, e, tp)
        local mf = ce:GetValue()
        sg2 = Duel.GetMatchingGroup(s.filter2, tp, LOCATION_EXTRA, 0, nil, e, tp, mg2, mf, chkf)
    end
    if sg1:GetCount() > 0 or (sg2 ~= nil and sg2:GetCount() > 0) then
        local sg = sg1:Clone()
        if sg2 then sg:Merge(sg2) end
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
        local tg = sg:Select(tp, 1, 1, nil)
        local tc = tg:GetFirst()
        if tc and tc:IsType(TYPE_MONSTER) then
            if sg1:IsContains(tc) and (sg2 == nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp, ce:GetDescription())) then
                local mat1 = Duel.SelectFusionMaterial(tp, tc, mg1, nil, chkf)
                tc:SetMaterial(mat1)
                Duel.SendtoGrave(mat1, REASON_EFFECT + REASON_MATERIAL + REASON_FUSION)
                Duel.BreakEffect()
                Duel.SpecialSummon(tc, SUMMON_TYPE_FUSION, tp, tp, false, false, POS_FACEUP)
            else
                local mat2 = Duel.SelectFusionMaterial(tp, tc, mg2, nil, chkf)
                local fop = ce:GetOperation()
                fop(ce, e, tp, tc, mat2)
            end
            tc:CompleteProcedure()
        end
    end
end