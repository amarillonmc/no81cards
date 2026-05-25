-- 大型投射机
local s,id=GetID()
function s.initial_effect(c)
    -- ①：发动时给对方500伤害
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
    -- ②：灵摆区域放置时的效果
    -- 灵摆效果1：结束阶段破坏自身并造成伤害，刻度4以上额外破坏怪兽
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
    -- 灵摆效果2：在右侧灵摆区时刻度变为左侧刻度+2
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
-- ①：发动时的伤害效果
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Damage(1-tp,500,REASON_EFFECT)
end
-- 灵摆效果1的条件：自己回合的结束阶段
function s.pendcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
-- 灵摆效果1的目标：准备破坏自身并造成伤害，刻度4以上额外准备破坏怪兽
function s.pendtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local scale=math.max(c:GetLeftScale(),c:GetRightScale())
    if chk==0 then return true end
    Duel.SetTargetCard(c)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,c,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,scale*500)
    -- 如果刻度>=4，额外添加破坏怪兽的操作信息
    if scale>=4 then
        local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,nil)
        if #g>0 then
            Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_MZONE)
        end
    end
end
-- 灵摆效果1的操作：破坏自身并造成伤害，刻度4以上额外破坏对方怪兽
function s.pendop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    local scale=math.max(c:GetLeftScale(),c:GetRightScale())
    if Duel.Destroy(c,REASON_EFFECT)~=0 then
        Duel.Damage(1-tp,scale*500,REASON_EFFECT)
        -- 刻度>=4的话，额外破坏对方怪兽区的卡
        if scale>=4 then
            Duel.Hint(HINT_SELECTMSG,tp,HINT_DESTROY)
            local g=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,0,LOCATION_MZONE,1,1,nil)
            if #g>0 then
                Duel.Destroy(g,REASON_EFFECT)
            end
        end
    end
end
-- 灵摆效果2的刻度修正值
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