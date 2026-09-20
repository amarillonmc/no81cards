--潜藏的危机
local s,id,o=GetID()
function s.initial_effect(c)
    -- ① 通常陷阱：怪兽从自己场上离开的场合发动
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SSET)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_LEAVE_FIELD)
    e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
    e1:SetCountLimit(1,id)
    e1:SetCondition(s.setcon)
    e1:SetTarget(s.settg)
    e1:SetOperation(s.setop)
    c:RegisterEffect(e1)

    -- ② 墓地：表侧表示的陷阱卡从自己场上离开的场合，除外自身
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_DRAW)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_LEAVE_FIELD)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCountLimit(1,id+1)
    e2:SetCondition(s.actcon)
    e2:SetCost(aux.bfgcost)
    e2:SetTarget(s.acttg)
    e2:SetOperation(s.actop)
    c:RegisterEffect(e2)
end

-- ① 触发条件：怪兽从自己场上离开（含怪兽区的陷阱怪兽）
function s.setcfilter(c,tp)
    return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE)
end
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(s.setcfilter,1,nil,tp)
end

-- ① filter：陷阱卡 + 可盖放 + IsFaceupEx（排除里侧除外的卡）
function s.setfilter(c)
    return c:IsType(TYPE_TRAP) and c:IsSSetable() and c:IsFaceupEx()
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return false end
        return Duel.IsExistingMatchingCard(s.setfilter,tp,
            LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,nil)
    end
    Duel.SetOperationInfo(0,CATEGORY_SSET,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
    -- 王谷检测放在 op：王谷不限制发动，只让处理时不适用
    local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.setfilter),tp,
        LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,nil)
    if #g==0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
    local sg=g:Select(tp,1,1,nil)
    if #sg>0 then
        Duel.SSet(tp,sg)
    end
end

-- ② 触发条件：表侧表示的陷阱卡从自己场上离开
-- GetOriginalType 涵盖陷阱怪兽（含"不当作陷阱卡使用"的变体）
function s.actcfilter(c,tp)
    return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_ONFIELD)
        and c:IsPreviousPosition(POS_FACEUP)
        and c:GetOriginalType()&TYPE_TRAP~=0
end
function s.actcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(s.actcfilter,1,nil,tp)
end

function s.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.actop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local b1=true
    local b2=Duel.IsPlayerCanDraw(tp,1)
    local op=0
    if b1 and b2 then
        op=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))
    elseif b2 then
        op=1
    end
    if op==0 then
        local e1=Effect.CreateEffect(c)
        e1:SetDescription(aux.Stringid(id,4))
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
        e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
        e1:SetTargetRange(LOCATION_SZONE,0)
        e1:SetCountLimit(1)
        e1:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(e1,tp)
    else
        Duel.Draw(tp,1,REASON_EFFECT)
    end
end