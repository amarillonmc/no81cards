-- 山茶花幻象
local s,id=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,60013012)
    -- 反击陷阱的效果
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_DISABLE+CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_CHAINING)
    e1:SetCountLimit(1,id) -- 这个卡名的效果1回合只能使用1次
    e1:SetCondition(s.condition)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
end
-- 检查场上的维若妮卡
function s.veronica_filter(c)
    return c:GetCode()==60013012
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
    -- 1. 自己场上有「正义的反派 维若妮卡」
    if not Duel.IsExistingMatchingCard(s.veronica_filter,tp,LOCATION_ONFIELD,0,1,nil) then return false end
    -- 2. 发动的是怪兽效果/魔法/陷阱，并且可以被无效
    return re:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) and Duel.IsChainNegatable(ev)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local rc=re:GetHandler()
    -- 设置无效和除外的操作信息
    Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
    if rc:IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
    end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local rc=re:GetHandler()
    -- 无效发动
    if Duel.NegateActivation(ev) then
        -- 把发动的卡除外
        if rc:IsRelateToEffect(re) then
            Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)
        end
    end
end
