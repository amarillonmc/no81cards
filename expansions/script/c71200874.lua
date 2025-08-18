-- 焰速轰鸣冲刺
local s,id=GetID()
function s.initial_effect(c)
    c:SetUniqueOnField(1,0,id)
    
    -- 效果①：特殊召唤+超量召唤
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
    e1:SetCondition(s.spcon)
    e1:SetTarget(s.sptg)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)
    
    -- 效果②：墓地回收
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,id+100,EFFECT_COUNT_CODE_OATH)
    e2:SetCost(s.thcost)
    e2:SetTarget(s.thtg)
    e2:SetOperation(s.thop)
    c:RegisterEffect(e2)
end

-- 效果①条件：同名怪兽检测函数
function s.spfilter(c,tp)
    return c:IsSetCard(0x893) and c:IsType(TYPE_MONSTER)
        and not Duel.IsExistingMatchingCard(s.namefilter,tp,LOCATION_MZONE,0,1,nil,c:GetCode())
end

function s.namefilter(c,code)
    return c:IsCode(code) and c:IsFaceup()
end

-- 效果①发动条件
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
    -- 特殊召唤条件
    local sp_check = Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
        and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,tp)
    
    -- 超量召唤条件
    local xyz_check = Duel.IsExistingMatchingCard(s.xyzfilter,tp,LOCATION_EXTRA,0,1,nil)
    
    return sp_check and xyz_check
end

-- 效果①目标确认
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then 
        return s.spcon(e,tp,eg,ep,ev,re,r,rp)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end

-- 效果①操作
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    -- 特殊召唤部分
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
    if #g==0 or Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)==0 then return end
    
    -- 超量召唤部分
    local xyzg=Duel.GetMatchingGroup(s.xyzfilter,tp,LOCATION_EXTRA,0,nil)
    if #xyzg>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
        Duel.XyzSummon(tp,xyz,nil)
    end
end

-- 超量怪兽检测
function s.xyzfilter(c)
    return c:IsXyzSummonable(nil)
end

-- 效果②代价
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
    Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end

-- 效果②目标
function s.thfilter(c)
    return c:IsSetCard(0x893) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
        return g:GetClassCount(Card.GetCode)>=2
    end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_MZONE+LOCATION_GRAVE)
end

-- 效果②操作
function s.thop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.thfilter),tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
    if g:GetClassCount(Card.GetCode)<2 then return end
    
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local tg=Group.CreateGroup()
    
    -- 第一只
    local g1=g:Select(tp,1,1,nil)
    tg:Merge(g1)
    g:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
    
    -- 第二只
    local g2=g:Select(tp,1,1,nil)
    tg:Merge(g2)
    
    if #tg==2 then
        Duel.SendtoHand(tg,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,tg)
    end
end