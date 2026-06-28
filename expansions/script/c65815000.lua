-- 任务：T1-废土
--T1-废土
local s,id,o=GetID()
function s.initial_effect(c)
    -- 发动效果
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0,TIMING_STANDBY_PHASE)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
    -- 对方先攻第1回合准备阶段从手卡发动
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
    e2:SetCondition(s.handcon)
    c:RegisterEffect(e2)
end

function s.handcon(e)
    local tp=e:GetHandlerPlayer()
	return Duel.GetTurnCount()==1 and Duel.GetTurnPlayer()==1-tp
		and Duel.GetCurrentPhase()==PHASE_STANDBY
end

-- 放置兵营的过滤
function s.barrackfilter(c,tp)
    return c:IsCode(65814055) and not c:IsForbidden() and c:CheckUniqueOnField(tp,LOCATION_SZONE)
end

-- 特殊召唤雷诺的过滤
function s.spfilter(c,e,tp)
    return c:IsCode(65814080) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false)
        and Duel.GetLocationCountFromEx(tp,tp,nil,c,0x60)>0
end

-- 发动条件检查
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        -- 需要至少一个魔陷区空位（放置兵营）
        if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return false end
        -- 手卡·卡组·墓地存在兵营
        if not Duel.IsExistingMatchingCard(s.barrackfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) then return false end
        -- 额外卡组存在可特殊召唤到EX区的雷诺
        if not Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) then return false end
        return true
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end

-- 发动处理
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()

    -- 1. 放置「起义呐喊 兵营」
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
    local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.barrackfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
    if tc then
        Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    else
        return -- 没有兵营则后续不处理
    end

    -- 2. 特殊召唤「起义军领袖 雷诺」到额外怪兽区域
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local sc=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
    if sc then
        Duel.SpecialSummon(sc,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP,0x60)
				sc:CompleteProcedure()
    end
end
