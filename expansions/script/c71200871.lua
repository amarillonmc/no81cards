-- 焰速轰鸣 开拓者Δ
local s,id=GetID()
function s.initial_effect(c)
    -- 超量召唤设置
    c:EnableReviveLimit()
    aux.AddXyzProcedureLevelFree(c,s.mfilter,nil,2,2)
    
    -- 效果①：取除素材提升攻击力
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,id)
    e1:SetCondition(s.atkcon)
    e1:SetCost(s.atkcost)
    e1:SetOperation(s.atkop)
    c:RegisterEffect(e1)
    
    -- 注册超量召唤标志
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e0:SetCode(EVENT_SPSUMMON_SUCCESS)
    e0:SetOperation(s.regop)
    c:RegisterEffect(e0)
    
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
    return c:IsSetCard(0x893) or c:IsLevel(4)
end

-- 注册超量召唤标志
function s.regop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsSummonType(SUMMON_TYPE_XYZ) then
        c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
    end
end

-- 效果①发动条件（只能在超量召唤的回合发动）
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetFlagEffect(id)>0
end

function s.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end

function s.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsFaceup() and c:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(c:GetDefense())
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
        c:RegisterEffect(e1)
    end
end

-- 效果②条件：成为超量素材
function s.efcon(e,tp,eg,ep,ev,re,r,rp)
    return r==REASON_XYZ and e:GetHandler():GetReasonCard():IsSetCard(0x893)
end

-- 效果②操作：赋予宿主超量召唤时抽卡效果
function s.efop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local rc=c:GetReasonCard()
    
    -- 添加效果：超量召唤成功时抽1张
    local e1=Effect.CreateEffect(rc)
    e1:SetDescription(aux.Stringid(id,1))
    e1:SetCategory(CATEGORY_DRAW)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCondition(s.drcon)
    e1:SetTarget(s.drtg)
    e1:SetOperation(s.drop)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
    rc:RegisterEffect(e1)
    
    -- 如果宿主不是效果怪兽，添加效果类型
    if not rc:IsType(TYPE_EFFECT) then
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_ADD_TYPE)
        e2:SetValue(TYPE_EFFECT)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD)
        rc:RegisterEffect(e2,true)
    end
end

function s.drcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end

function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

function s.drop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
end