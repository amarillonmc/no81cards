-- 焰速轰鸣急行
local s,id=GetID()
function s.initial_effect(c)
    -- 效果①：破坏对方场上1张卡
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,{id,1})
    e1:SetCondition(s.descon)
    e1:SetTarget(s.destg)
    e1:SetOperation(s.desop)
    c:RegisterEffect(e1)
    
    -- 效果②：墓地除外无效攻击
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_DISABLE)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_BE_BATTLE_TARGET)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,{id,2})
    e2:SetCondition(s.atkcon)
    e2:SetCost(s.atkcost)
    e2:SetTarget(s.atktg)
    e2:SetOperation(s.atkop)
    c:RegisterEffect(e2)
end

-- 效果①条件：自己场上有焰速轰鸣怪兽
function s.desfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x893)
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(s.desfilter,tp,LOCATION_MZONE,0,1,nil)
end

-- 效果①目标：选择对方场上1张卡
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_ONFIELD)
end

-- 效果①操作：破坏选择的卡
function s.desop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
    if #g>0 then
        Duel.Destroy(g,REASON_EFFECT)
    end
end

-- 效果②条件：自己的焰速轰鸣怪兽成为攻击对象
function s.atkfilter(c,tp)
    return c:IsFaceup() and c:IsSetCard(0x893) and c:IsControler(tp)
end
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(s.atkfilter,1,nil,tp)
end

-- 效果②代价：从墓地除外自身
function s.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
    Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end

-- 效果②目标：无特别操作
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end

-- 效果②操作：无效攻击
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
    Duel.NegateAttack()
end