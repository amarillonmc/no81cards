-- 焰速轰鸣 裁判β
local s,id=GetID()
function s.initial_effect(c)
    -- 超量召唤设置
    c:EnableReviveLimit()
    aux.AddXyzProcedureLevelFree(c,s.mfilter,nil,3,3)
    
    -- 注册超量召唤标志
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e0:SetCode(EVENT_SPSUMMON_SUCCESS)
    e0:SetOperation(s.regop)
    c:RegisterEffect(e0)
    
    -- 效果①：取除素材特殊召唤
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,id)
    e1:SetCondition(s.spcon)
    e1:SetCost(s.spcost)
    e1:SetTarget(s.sptg)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)
    
    -- 效果②：作为素材赋予宿主效果
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_BE_MATERIAL)
    e2:SetCondition(s.efcon)
    e2:SetOperation(s.efop)
    c:RegisterEffect(e2)
end

-- 超量素材检测
function s.mfilter(c,xyzc)
    return c:IsSetCard(0x893) or c:IsLevel(5)  -- 焰速轰鸣或任意5星怪兽
end

-- 注册超量召唤标志
function s.regop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsSummonType(SUMMON_TYPE_XYZ) then
        c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
    end
end

-- 效果①发动条件（只能在超量召唤的回合发动）
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetFlagEffect(id)>0
end

function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end

function s.spfilter(c,e,tp)
    return c:IsSetCard(0x893) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
            and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
    if #g>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end

-- 效果②条件：成为超量素材
function s.efcon(e,tp,eg,ep,ev,re,r,rp)
    return r==REASON_XYZ and e:GetHandler():GetReasonCard():IsSetCard(0x893)
end

-- 效果②操作：赋予宿主两个效果
function s.efop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local rc=c:GetReasonCard()
    
    -- 效果1：不会被效果破坏
    local e1=Effect.CreateEffect(rc)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(1)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
    rc:RegisterEffect(e1)
    
    -- 效果2：场上机械族怪兽攻击力上升200
    local e2=Effect.CreateEffect(rc)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_MACHINE))
    e2:SetValue(200)
    e2:SetReset(RESET_EVENT+RESETS_STANDARD)
    rc:RegisterEffect(e2)
    
    -- 如果宿主不是效果怪兽，添加效果类型
    if not rc:IsType(TYPE_EFFECT) then
        local e3=Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_ADD_TYPE)
        e3:SetValue(TYPE_EFFECT)
        e3:SetReset(RESET_EVENT+RESETS_STANDARD)
        rc:RegisterEffect(e3,true)
    end
end