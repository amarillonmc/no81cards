--于此结霜，再塑寒冬
local s,id,o=GetID()
function s.initial_effect(c)
    aux.AddCodeList(c,43492000)
    --①效果：仪式召唤
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,id)
    e1:SetCondition(s.ritcon)
    e1:SetTarget(s.rittg)
    e1:SetOperation(s.ritop)
    c:RegisterEffect(e1)

    --②效果：被解放时适用①
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_RELEASE)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,id+1)
    e2:SetTarget(s.rittg)
    e2:SetOperation(s.ritop)
    c:RegisterEffect(e2)

    --全局监听：统计长夜归息(43492000)的发动次数
    if not s.global_check then
        s.global_check=true
        local ge1=Effect.CreateEffect(c)
        ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        ge1:SetCode(EVENT_CHAINING)
        ge1:SetOperation(s.regop)
        Duel.RegisterEffect(ge1,0)
    end
end

function s.regop(e,tp,eg,ep,ev,re,r,rp)
    local rc=re:GetHandler()
    if rc:IsCode(43492000) and re:IsActivated() then
        Duel.RegisterFlagEffect(rp,43492000,RESET_PHASE+PHASE_END,0,1)
    end
end

--①效果发动条件：场上所有怪兽都是表侧表示的长夜归息，且发动过3次以上
function s.cfilter(c)
    return c:IsFaceup() and c:IsCode(43492000)
end
function s.ritcon(e,tp,eg,ep,ev,re,r,rp)
    local ct=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
    return Duel.GetFlagEffect(tp,43492000)>=3 and ct>0 and ct==Duel.GetMatchingGroupCount(s.cfilter,tp,LOCATION_MZONE,0,nil)
end

--仪式怪兽过滤：手卡·卡组的本家仪式怪兽
function s.ritfilter(c,e,tp)
    return c:IsSetCard(0x3f15) and c:IsType(TYPE_RITUAL)
        and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
end

--解放素材过滤：手卡·场上的可解放怪兽
function s.ritmatfilter(c,tp)
    return c:IsType(TYPE_MONSTER) and c:IsReleasable()
end

--目标
function s.rittg(e,tp,eg,ep,ev,re,r,rp,chk)
    local rg = Duel.GetMatchingGroup(s.ritfilter, tp, LOCATION_HAND + LOCATION_DECK, 0, nil, e, tp)
    if #rg == 0 then return false end
    if chk == 0 then
        if Duel.GetLocationCount(tp, LOCATION_MZONE) <= 0 then return false end
        local mg = Duel.GetReleaseGroup(tp, true):Filter(s.ritmatfilter, nil, tp)
        -- 对每只候选仪式怪兽，排除自身后检查素材组合
        for rc in aux.Next(rg) do
            local lv = rc:GetLevel()
            local temp_mg = mg:Clone()
            temp_mg:RemoveCard(rc)
            if temp_mg:CheckSubGroup(aux.RitualCheckEqual, 1, 99, rc, lv) then
                return true
            end
        end
        return false
    end
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_HAND + LOCATION_DECK)
end

--操作
function s.ritop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp, LOCATION_MZONE) <= 0 then return end
    --选择仪式怪兽
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
    local rg = Duel.GetMatchingGroup(s.ritfilter, tp, LOCATION_HAND + LOCATION_DECK, 0, nil, e, tp)
    local rc = rg:Select(tp, 1, 1, nil):GetFirst()
    if not rc then return end
    local lv = rc:GetLevel()
    -- 包含手卡怪兽的素材组，排除要特招的仪式怪兽自身
    local mg = Duel.GetReleaseGroup(tp, true):Filter(s.ritmatfilter, nil, tp)
    mg:RemoveCard(rc)
    if mg:CheckSubGroup(aux.RitualCheckEqual, 1, 99, rc, lv) then
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_RELEASE)
        local mat = mg:SelectSubGroup(tp, aux.RitualCheckEqual, false, 1, 99, rc, lv)
        if mat then
            rc:SetMaterial(mat)
            Duel.Release(mat, REASON_COST)
            Duel.BreakEffect()
            Duel.SpecialSummon(rc, SUMMON_TYPE_RITUAL, tp, tp, false, true, POS_FACEUP)
            rc:CompleteProcedure()
        end
    end
end