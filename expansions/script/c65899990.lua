-- 我突然释怀的笑
local s,id=GetID()
function s.initial_effect(c)
    -- 这张卡在对方把效果发动过的回合也能从手卡发动
    local e0=Effect.CreateEffect(c)
		e0:SetDescription(aux.Stringid(id,0))
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
    e0:SetCondition(s.handcon)
    c:RegisterEffect(e0)

    -- 作为永续陷阱的基本卡片发动（不包含效果处理的空发动）
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)

    -- ①：每次对方把卡的效果发动才发动。那个发动无效。
    -- 【严格遵循你的要求：场合诱发必发（TRIGGER_F）】
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

    Duel.AddCustomActivityCounter(id,ACTIVITY_CHAIN,aux.TRUE)
end

---------------- 手卡发动条件 ----------------
function s.handcon(e)
    local tp=e:GetHandlerPlayer()
    -- 如果对方(1-tp)在这个回合的标记大于0，则允许手发
    return Duel.GetCustomActivityCount(id,1-tp,ACTIVITY_CHAIN)~=0
end

---------------- ①效果：必发诱发的“那个发动无效” ----------------
function s.discon(e,tp,eg,ep,ev,re,r,rp)
    -- 每次对方把卡的效果发动
    return rp==1-tp
end

function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    -- 必发效果，chk==0 时直接 return true
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end

function s.disop(e,tp,eg,ep,ev,re,r,rp)
    -- 强行对着刚才那个连锁序号 ev 喊无效
    Duel.NegateActivation(ev)
end