-- 神石镇压 (71500305)
local s,id=GetID()
function s.initial_effect(c)
    -- ①：发动无效并除外
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE+CATEGORY_RELEASE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_CHAINING)
    e1:SetCondition(s.condition)
    e1:SetCost(s.cost)
    e1:SetTarget(s.target)
    e1:SetOperation(s.operation)
    c:RegisterEffect(e1)
    
    -- ②：墓地效果
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_LEAVE_FIELD)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCondition(s.gycon)
    e2:SetOperation(s.gyop)
    c:RegisterEffect(e2)
end

-- 修正：天使族过滤
function s.costfilter(c)
    return c:IsRace(RACE_FAIRY)
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
    -- 修正：使用 IsActiveType 替代报错的 IsBaseType
    return re:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    -- 修正：使用更通用的 Duel.CheckReleaseGroup 替代报错的 CheckReleaseGroupCost
    if chk==0 then return Duel.CheckReleaseGroup(tp,s.costfilter,1,false,1,true,e:GetHandler(),nil,nil,nil,nil) end
    local g=Duel.SelectReleaseGroup(tp,s.costfilter,1,1,false,1,true,e:GetHandler(),nil,nil,nil,nil)
    Duel.Release(g,REASON_COST)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
    end
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
    local rc=re:GetHandler()
    
    -- 在判定无效前，记录卡片是否在场及其位置
    local is_onfield = rc:IsOnField()
    local p, loc, seq
    if is_onfield then
        p = rc:GetControler()
        loc = rc:GetLocation()
        seq = rc:GetSequence()
    end

    -- 尝试无效。如果对方受保护，无效会失败（返回 false）
    if Duel.NegateActivation(ev) then
        -- 只有无效成功，才会尝试除外
        if rc:IsRelateToEffect(re) and Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)>0 then
            -- 如果除外的是场上的卡，封锁区域
            if is_onfield and rc:IsLocation(LOCATION_REMOVED) then
                local dis = 0
                if loc == LOCATION_MZONE then
                    dis = 1 << seq
                elseif loc == LOCATION_SZONE then
                    dis = 1 << (seq + 8)
                end

                if dis ~= 0 then
                    -- 如果是对方的卡，偏移 16 位
                    if p ~= tp then dis = dis << 16 end
                    
                    local e1=Effect.CreateEffect(e:GetHandler())
                    e1:SetType(EFFECT_TYPE_FIELD)
                    e1:SetCode(EFFECT_DISABLE_FIELD)
                    e1:SetOperation(function(e) return dis end)
                    e1:SetReset(RESET_PHASE+PHASE_END)
                    Duel.RegisterEffect(e1,tp)
                    -- 视觉提示
                    Duel.Hint(HINT_ZONE,tp,dis)
                    Duel.Hint(HINT_ZONE,1-tp,dis)
                end
            end
        end
    end
end

-- ② 墓地效果
function s.gyfilter(c,tp)
    return c:IsPreviousPosition(POS_FACEDOWN) 
        and c:IsPreviousControler(tp) 
        and c:IsPreviousLocation(LOCATION_ONFIELD)
        and c:GetReasonPlayer()==1-tp 
        and (c:GetReason()&REASON_EFFECT)~=0
end
function s.gycon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(s.gyfilter,1,nil,tp)
end
function s.gyop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLEFIELD)
    -- 选择一个没有使用的区域封锁
    local dis=Duel.SelectDisableField(tp,1,LOCATION_ONFIELD,LOCATION_ONFIELD,0)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_DISABLE_FIELD)
    e1:SetOperation(function(e) return dis end)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
    Duel.Hint(HINT_ZONE,tp,dis)
    Duel.Hint(HINT_ZONE,1-tp,dis)
end