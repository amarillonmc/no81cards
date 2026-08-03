-- 我突然释怀的笑
local s,id=GetID()
function s.initial_effect(c)
    local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
    e0:SetCondition(s.handcon)
    c:RegisterEffect(e0)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    --作者裁定：这张卡发动时不能康对面效果
    e1:SetTarget(s.tg)
    c:RegisterEffect(e1)
    --这个描述就是场合诱发必发，没有任何bug，参考ocg神碑绿阵，偷偷恶意传修复的直接死全家
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_NEGATE)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_CHAINING)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCondition(s.discon)
    e2:SetTarget(s.distg)
    e2:SetOperation(s.disop)
    c:RegisterEffect(e2)
    Duel.AddCustomActivityCounter(id,ACTIVITY_CHAIN,aux.FALSE)
end

function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESET_CHAIN,0,1)
end

function s.handcon(e)
    local tp=e:GetHandlerPlayer()
    return Duel.GetCustomActivityCount(id,1-tp,ACTIVITY_CHAIN)~=0
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
    return rp==1-tp and e:GetHandler():GetFlagEffect(id)==0
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
    Duel.NegateActivation(ev)
end