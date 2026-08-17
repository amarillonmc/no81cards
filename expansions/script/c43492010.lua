-- 凄陌寒昼·孤掷破冰
local s,id,o=GetID()
function s.initial_effect(c)
    aux.AddCodeList(c,43492000)
    --①效果：召唤成功时触发
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,id)
    e1:SetTarget(s.sptg)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)
    --①效果：特殊召唤成功时触发
    local e2=e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2)
    --①效果：被解放时触发
    local e3=e1:Clone()
    e3:SetCode(EVENT_RELEASE)
    e3:SetRange(LOCATION_GRAVE)
    c:RegisterEffect(e3)

    --②效果：墓地诱发，本回合长夜归息发动3次以上，且有卡被解放
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id,0))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_RELEASE)
    e4:SetRange(LOCATION_GRAVE)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetCountLimit(1,id+1)
    e4:SetCondition(s.ritcon)
    e4:SetTarget(s.rittg)
    e4:SetOperation(s.ritop)
    c:RegisterEffect(e4)

    --全局监听：统计长夜归息的发动次数
    if not s.global_check then
        s.global_check=true
        local ge1=Effect.CreateEffect(c)
        ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        ge1:SetCode(EVENT_CHAINING)
        ge1:SetOperation(s.regop)
        Duel.RegisterEffect(ge1,0)
    end
end

--全局监听操作：当长夜归息发动时，为玩家注册计数Flag
function s.regop(e,tp,eg,ep,ev,re,r,rp)
    local rc=re:GetHandler()
    if rc:IsCode(43492000) then
        Duel.RegisterFlagEffect(rp,id,RESET_PHASE+PHASE_END,0,1)
    end
end

--①效果：从卡组特召本家怪兽（自身除外）
function s.spfilter(c,e,tp)
    return c:IsSetCard(0x3f15) and c:IsType(TYPE_MONSTER) and not c:IsCode(id)
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    if #g>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end

--②效果条件：长夜归息发动3次以上，且本事件中有卡被解放
function s.ritcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFlagEffect(tp,id)>=3 and not eg:IsContains(e:GetHandler())
end

--仪式怪兽过滤：手卡·卡组的本家仪式怪兽
function s.ritfilter(c,e,tp)
    return c:IsSetCard(0x3f15) and c:IsType(TYPE_RITUAL)
        and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
end

--可解放素材过滤：手卡·场上的可解放怪兽
function s.ritmatfilter(c,tp)
    return c:IsType(TYPE_MONSTER) and c:IsReleasable()
end

--目标
function s.rittg(e,tp,eg,ep,ev,re,r,rp,chk)
    local rg = Duel.GetMatchingGroup(s.ritfilter, tp, LOCATION_HAND + LOCATION_DECK, 0, nil, e, tp)
    if #rg == 0 then return false end
    -- 包含手卡怪兽的素材组
    local mg = Duel.GetReleaseGroup(tp, true):Filter(s.ritmatfilter, nil, tp)
    if chk == 0 then
        -- 必须有空位
        if Duel.GetLocationCount(tp, LOCATION_MZONE) <= 0 then return false end
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