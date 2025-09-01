-- 抓住希望 
local s,id=GetID()
function s.initial_effect(c)
    
    -- 效果①: 检索手牌并送墓
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_HANDES)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,id)
    e1:SetTarget(s.thtg)
    e1:SetOperation(s.thop)
    c:RegisterEffect(e1)
    
    -- 效果②: 墓地效果 - 控制权夺取
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_CONTROL)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,id+1)
    e2:SetCondition(s.ctcon)
    e2:SetCost(s.ctcost)
    e2:SetTarget(s.cttg)
    e2:SetOperation(s.ctop)
    c:RegisterEffect(e2)
end

-- 效果①: 检索目标
function s.thfilter(c,code)
    return c:IsCode(code) and c:IsAbleToHand()
end

-- 效果①: 目标设置
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local g1=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,nil,68535320)
        local g2=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,nil,95929069)
        return #g1>0 and #g2>0
    end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK+LOCATION_REMOVED)
    Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end

-- 效果①: 操作
function s.thop(e,tp,eg,ep,ev,re,r,rp)
    local g1=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,nil,68535320)
    local g2=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,nil,95929069)
    
    if #g1>0 and #g2>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local sg1=g1:Select(tp,1,1,nil)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local sg2=g2:Select(tp,1,1,nil)
        sg1:Merge(sg2)
        
        if #sg1==2 and Duel.SendtoHand(sg1,nil,REASON_EFFECT)==2 then
            Duel.ConfirmCards(1-tp,sg1)
            Duel.ShuffleHand(tp)
            Duel.BreakEffect()
            Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
        end
    end
end

-- 效果②: 条件检查 - 岩石族超量存在
function s.rockxyzfilter(c)
    return c:IsFaceup() and c:IsRace(RACE_ROCK) and c:IsType(TYPE_XYZ)
end

-- 效果②: 条件检查 - 对方从额外特殊召唤
function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(s.rockxyzfilter,tp,LOCATION_MZONE,0,1,nil)
        and eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp) and eg:IsExists(Card.IsLocation,1,nil,LOCATION_MZONE)
        and eg:GetFirst():IsSummonType(SUMMON_TYPE_SPECIAL) and eg:GetFirst():IsPreviousLocation(LOCATION_EXTRA)
end

-- 效果②: 代价 - 从墓地除外
function s.ctcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
    Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end

-- 效果②: 目标设置
function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,0,0)
end

-- 效果②: 操作
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
    local g=Duel.SelectMatchingCard(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
    local tc=g:GetFirst()
    if tc and Duel.GetControl(tc,tp) then -- 永久获得控制权
        -- 效果无效化
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e2)
        
        -- 攻击力变成2500
        local e3=Effect.CreateEffect(e:GetHandler())
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_SET_ATTACK_FINAL)
        e3:SetValue(2500)
        e3:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e3)
        
        -- 卡名当作「No.39 希望皇 霍普」
        local e4=Effect.CreateEffect(e:GetHandler())
        e4:SetType(EFFECT_TYPE_SINGLE)
        e4:SetCode(EFFECT_CHANGE_CODE)
        e4:SetValue(84013237)
        e4:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e4)
    end
end