-- 连射投射机
local s,id=GetID()
function s.initial_effect(c)
    -- ①：发动时给对方400伤害，重复1次
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
    -- ②：灵摆区域放置时的效果
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_PHASE+PHASE_END)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCountLimit(1)
    e2:SetCondition(s.pendcon)
    e2:SetTarget(s.pendtg)
    e2:SetOperation(s.pendop)
    c:RegisterEffect(e2)
    -- 灵摆刻度修正：右侧灵摆区时刻度变为左侧刻度+2
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_UPDATE_LSCALE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_PZONE)
    e3:SetValue(s.scval)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EFFECT_UPDATE_RSCALE)
    c:RegisterEffect(e4)
end
-- ①：发动时的重复伤害效果
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    -- 两次400伤害
    Duel.Damage(1-tp,400,REASON_EFFECT)
    Duel.Damage(1-tp,400,REASON_EFFECT)
end
-- 灵摆效果的条件：自己回合的结束阶段
function s.pendcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
-- 灵摆效果的目标
function s.pendtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local scale=math.max(c:GetLeftScale(),c:GetRightScale())
    if chk==0 then return true end
    Duel.SetTargetCard(c)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,c,1,0,0)
    -- 两次刻度×400的伤害，总伤害为scale*800
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,scale*400*2)
end
-- 灵摆效果的操作
function s.pendop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    local scale=math.max(c:GetLeftScale(),c:GetRightScale())
    if Duel.Destroy(c,REASON_EFFECT)~=0 then
        -- 两次刻度×400的伤害
        Duel.Damage(1-tp,scale*400,REASON_EFFECT)
        Duel.Damage(1-tp,scale*400,REASON_EFFECT)
    end
end
-- 灵摆刻度修正值
function s.scval(e,c)
    local tp=e:GetHandlerPlayer()
    local seq=e:GetHandler():GetSequence()
    -- 右侧灵摆区（seq=1）时，取左侧灵摆区的卡的刻度+2
    if seq==1 then
        local lc=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
        if lc then
            return lc:GetLeftScale()+2
        end
    end
    return 0
end