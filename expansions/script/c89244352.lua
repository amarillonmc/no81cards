-- 五禁玄光气 (卡密89244352)
local s,id=GetID()
if not id then id=89244352 end

function s.initial_effect(c)
    -- 连接召唤限制
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c, s.matfilter, 5, 5)
    
    -- 效果①：对方不能把卡解放
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_CANNOT_RELEASE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(0,1)
    c:RegisterEffect(e1)
    
    -- 效果②：表侧表示存在期间只有1次，对方不能发动本回合已发动过的同名卡效果
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCondition(s.cond_effect2)     
      -- 检查标志
    e2:SetOperation(s.activate_effect2)
    c:RegisterEffect(e2)
    
    -- 全局监听：记录对方本回合发动过的效果卡名
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_CHAINING)
    e3:SetOperation(s.recordop)
    Duel.RegisterEffect(e3,0)
    
    -- 效果③：对方效果发动时，对方场上怪兽攻-500，归零则破坏
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e4:SetCode(EVENT_CHAINING)
    e4:SetRange(LOCATION_MZONE)
    e4:SetOperation(s.atkdown)
    c:RegisterEffect(e4)
end

-- 连接素材：属性不同的怪兽5只
function s.matfilter(c)
    return true
end

-- 全局记录表：记录对方本回合发动过的卡名
s.recorded_codes={}

-- 记录对方发动过的效果卡名
function s.recordop(e,tp,eg,ep,ev,re,r,rp)
    if rp==1-tp then
        local rc=re:GetHandler()
        if rc then
            local code=rc:GetOriginalCode()
            if not s.recorded_codes[code] then
                s.recorded_codes[code]=true
            end
        end
    end
end

-- 效果②的条件：本卡未使用过（标志不存在）
function s.cond_effect2(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetFlagEffect(id)==0
end

-- 效果②的操作
function s.activate_effect2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    -- 标记该效果已使用（表侧存在期间仅一次）
    c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
    -- 添加限制：对方不能发动本回合已发动过的同名卡效果
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(0,1)
    e1:SetValue(s.limitval)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
    -- 提示信息
    Duel.Hint(HINT_CARD,0,id)
end

function s.limitval(e,re,tp)
    local rc=re:GetHandler()
    if not rc then return false end
    local code=rc:GetOriginalCode()
    return s.recorded_codes[code]==true
end

-- 效果③的攻击力下降和破坏
function s.atkdown(e,tp,eg,ep,ev,re,r,rp)
    if rp==1-tp then
        local g=Duel.GetMatchingGroup(Card.IsFaceup,1-tp,LOCATION_MZONE,0,nil)
        if #g==0 then return end
        for tc in aux.Next(g) do
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_UPDATE_ATTACK)
            e1:SetValue(-500)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
            tc:RegisterEffect(e1)
            -- 检查攻击力是否变为0
            local atk=tc:GetAttack()
            if atk<=0 then
                Duel.Destroy(tc,REASON_EFFECT)
            end
        end
    end
end