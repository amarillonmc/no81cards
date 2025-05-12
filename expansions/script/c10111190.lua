function c10111190.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c10111190.matfilter,1,1) 
    -- ①效果：连接召唤成功时特召通常怪兽
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(10111190,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCountLimit(1,10111190)
    e1:SetCondition(c10111190.spcon)
    e1:SetTarget(c10111190.sptg)
    e1:SetOperation(c10111190.spop)
    c:RegisterEffect(e1)
    
    -- ②效果：抽卡效果
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(10111190,1))
    e2:SetCategory(CATEGORY_DRAW)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,10111190+100)
    e2:SetCondition(c10111190.drcon)
    e2:SetTarget(c10111190.drtg)
    e2:SetOperation(c10111190.drop)
    c:RegisterEffect(e2)
end

function c10111190.matfilter(c)
	return c:IsAttack(2500) and c:IsDefense(2000) and c:IsType(TYPE_NORMAL)
end

-- ①效果条件：成功连接召唤
function c10111190.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end

-- ①效果目标选择
function c10111190.filter(c,e,tp)
    return c:IsType(TYPE_NORMAL) and (c:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED))
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10111190.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c10111190.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end

-- ①效果操作
function c10111190.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10111190.filter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
    if #g>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end

-- ②效果条件：没有其他效果怪兽
function c10111190.drcon(e,tp,eg,ep,ev,re,r,rp)
    return not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_MZONE,0,1,e:GetHandler(),TYPE_EFFECT)
end

-- ②效果计算数量
function c10111190.drfilter(c)
    return c:IsType(TYPE_NORMAL) and c:GetBaseAttack()==2500 and c:GetBaseDefense()==2000
end
function c10111190.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local ct=Duel.GetMatchingGroupCount(c10111190.drfilter,tp,LOCATION_MZONE,0,nil)
        return ct>0 and Duel.IsPlayerCanDraw(tp,ct)
    end
    local ct=Duel.GetMatchingGroupCount(c10111190.drfilter,tp,LOCATION_MZONE,0,nil)
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(ct)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end

-- ②效果操作
function c10111190.drop(e,tp,eg,ep,ev,re,r,rp)
    local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
    local ct=Duel.GetMatchingGroupCount(c10111190.drfilter,tp,LOCATION_MZONE,0,nil)
    if ct>0 then
        Duel.Draw(p,ct,REASON_EFFECT)
    end
end