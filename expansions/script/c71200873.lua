-- 焰速轰鸣 突破裁判αβ
local s,id=GetID()
function s.initial_effect(c)
    -- 超量召唤设置
    c:EnableReviveLimit()
    aux.AddXyzProcedureLevelFree(c,s.mfilter,nil,2,2)
    
    -- 效果①：取除素材无效卡片效果
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_DISABLE)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCost(s.discost)
    e1:SetTarget(s.distg)
    e1:SetOperation(s.disop)
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
    return c:IsSetCard(0x893) and c:IsType(TYPE_XYZ)  -- 焰速轰鸣超量怪兽
        or (c:IsRank(6) and c:IsType(TYPE_XYZ))      -- 或任意6阶超量怪兽
end

-- 效果①代价
function s.discost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end

-- 效果①目标选择
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and chkc:IsFaceup() and chkc:IsControler(1-tp) end
    if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end

-- 效果①操作：无效卡片效果
function s.disop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
        -- 无效效果
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
        
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e2)
    end
end

-- 效果②条件：成为超量素材
function s.efcon(e,tp,eg,ep,ev,re,r,rp)
    return r==REASON_XYZ and e:GetHandler():GetReasonCard():IsSetCard(0x893)
end

-- 效果②操作：赋予宿主超量召唤效果
function s.efop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local rc=c:GetReasonCard()
    
    -- 赋予宿主效果：进行超量召唤
    local e1=Effect.CreateEffect(rc)
    e1:SetDescription(aux.Stringid(id,1))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCost(s.xyzcost)
    e1:SetTarget(s.xyztg)
    e1:SetOperation(s.xyzop)
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

-- 赋予效果的代价
function s.xyzcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end

-- 赋予效果的目标
function s.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.xyzfilter,tp,LOCATION_EXTRA,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end

function s.xyzfilter(c)
    return c:IsXyzSummonable(nil)  -- 可进行超量召唤的怪兽
end

-- 赋予效果的操作：进行超量召唤
function s.xyzop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(s.xyzfilter,tp,LOCATION_EXTRA,0,nil)
    if #g>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local sc=g:Select(tp,1,1,nil):GetFirst()
        Duel.XyzSummon(tp,sc,nil)  -- 进行超量召唤
    end
end