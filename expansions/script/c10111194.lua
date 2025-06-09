local s,id=GetID()
function s.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_SPSUMMON_COUNT)
    -- 效果①：展示手卡+丢弃特召
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION) -- 启动效果
    e1:SetRange(LOCATION_HAND)
 	e1:SetCountLimit(1,id)
    e1:SetCost(s.cost)
    e1:SetTarget(s.target)
    e1:SetOperation(s.operation)
    c:RegisterEffect(e1)
    -- 效果②：特召成功时炸场+选择性堆墓
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TOGRAVE)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) -- 单体触发型效果
    e2:SetProperty(EFFECT_FLAG_DELAY) -- 允许连锁其他效果
    e2:SetCode(EVENT_SPSUMMON_SUCCESS) -- 特殊召唤成功时
	e2:SetCountLimit(1,id+100)
    e2:SetCondition(s.spcon) -- 添加特殊召唤条件限制
    e2:SetTarget(s.sptg)
    e2:SetOperation(s.spop)
    c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,3))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,id+101)
	e3:SetCondition(s.tgcon)
	e3:SetTarget(s.tgtg)
	e3:SetOperation(s.tgop)
	c:RegisterEffect(e3)
end

-- 展示手卡+丢弃COST
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsDiscardable(REASON_COST) 
        and Duel.IsExistingMatchingCard(s.discfilter,tp,LOCATION_HAND,0,1,c) end
    -- 展示手卡
    Duel.ConfirmCards(1-tp,c)
    -- 丢弃COST
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
    local g=Duel.SelectMatchingCard(tp,s.discfilter,tp,LOCATION_HAND,0,1,1,c)
    Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end

-- 丢弃过滤条件（雷族·光属性·非自身）
function s.discfilter(c)
    return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_THUNDER) and not c:IsCode(id)
end

-- 特召目标检查
function s.spfilter(c,e,tp)
    return c:IsCode(66722103) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

-- 特召目标选择
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and (Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
        or Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end

-- 效果处理：特召封狼雷坊
function s.operation(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
    if #g>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_COUNT_LIMIT)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(2)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

-- 条件：从手卡特殊召唤成功
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPreviousLocation(LOCATION_HAND) -- 确保从手卡特召
end

-- 目标处理：破坏对方全场怪兽 (兼容性修正)
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local dg=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
    if chk==0 then 
        return #dg>0
    end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,#dg,0,0)
    -- 不再使用SetPossibleOperationInfo
end

-- 效果处理：炸场+选择性堆墓 (优化兼容性)
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    -- 破坏对方全场怪兽
    local dg=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
    if #dg==0 then return end
    
    if Duel.Destroy(dg,REASON_EFFECT)>0 then
        -- 检查卡组是否有大狼雷鸣
        local g=Duel.GetMatchingGroup(s.tgfilter,tp,LOCATION_DECK,0,nil)
        if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
            local sg=g:Select(tp,1,1,nil)
            Duel.SendtoGrave(sg,REASON_EFFECT)
        end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_COUNT_LIMIT)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(2)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
    end
end

-- 堆墓过滤器（大狼雷鸣）
function s.tgfilter(c)
    return c:IsCode(13683298) and c:IsAbleToGrave()
end

function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function s.tgfilter1(c,e,tp)
	return c:IsCode(13683298) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) and
		(not c:IsLocation(LOCATION_EXTRA) and Duel.GetMZoneCount(tp)>0
		or c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0)
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tgfilter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.tgfilter1),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_COUNT_LIMIT)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(2)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end