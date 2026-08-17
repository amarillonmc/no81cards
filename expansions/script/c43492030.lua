-- 凄陌寒昼·往日追忆
local s,id,o=GetID()
function s.initial_effect(c)
    --①效果：通常发动
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
    e1:SetCountLimit(1,id)
    e1:SetCondition(s.cond1)
    e1:SetTarget(s.tg)
    e1:SetOperation(s.op)
    c:RegisterEffect(e1)
    --②效果：被解放时发动，适用①
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_RELEASE)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCountLimit(1,id+1)
    e2:SetTarget(s.tg)
    e2:SetOperation(s.op)
    c:RegisterEffect(e2)
end

--①效果条件：自己场上有5星以上的「凄陌寒昼」怪兽
function s.cond1(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(s.lvfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.lvfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x3f15) and c:IsLevelAbove(5)
end

--目标：检查对方场上有可破坏的卡
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_ONFIELD)
end

--操作：选对方场上最多2张卡破坏（不取对象）
function s.op(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_ONFIELD,nil)
    if #g==0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local sg=g:Select(tp,1,2,nil)
    if #sg>0 then
        Duel.HintSelection(sg)
        Duel.Destroy(sg,REASON_EFFECT)
    end
end