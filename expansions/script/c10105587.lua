function c10105587.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
   -- 效果①：场上的永劫龙灾抗性
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)          -- 影响全场的效果
    e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT) -- 不会被对方效果破坏
    e1:SetRange(LOCATION_FZONE)            -- 此卡在场上时生效
    e1:SetTargetRange(LOCATION_MZONE,0)    -- 控制我方场上怪兽
    e1:SetTarget(c10105587.tgtg)
    e1:SetValue(aux.tgoval)
    c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10105587,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,10105587)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTarget(c10105587.target)
	e2:SetOperation(c10105587.operation)
	c:RegisterEffect(e2)
   -- ③效果：特殊召唤成功时回收卡
    local e3=Effect.CreateEffect(c)  -- 修改为 e3
    e3:SetCategory(CATEGORY_TODECK)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetRange(LOCATION_FZONE)
    e3:SetCondition(c10105587.tdcon)
    e3:SetTarget(c10105587.tdtg)
    e3:SetOperation(c10105587.tdop)
    c:RegisterEffect(e3)  -- 注册 e3
end
-- 抗性目标筛选
function c10105587.tgtg(e,c)
    return c:IsSetCard(0x7cca) and c:IsFaceup() -- 字段匹配且表侧表示
end
function c10105587.filter(c,e,sp)
	return c:IsSetCard(0x7cca) and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function c10105587.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10105587.filter,tp,LOCATION_HAND+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_REMOVED)
end
function c10105587.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10105587.filter,tp,LOCATION_HAND+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
-- 条件检查：特殊召唤的是7cca字段怪兽
function c10105587.cfilter(c)
    return c:IsSetCard(0x7cca) and c:IsType(TYPE_MONSTER)
end
function c10105587.tdcon(e,tp,eg)
    return eg:IsExists(c10105587.cfilter,1,nil)
end

-- 目标选择：双方墓地/除外的卡
function c10105587.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end

-- 效果处理：返回对应卡组
function c10105587.tdop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then
        local dest=0
        -- 判断是否是额外卡组怪兽
        if tc:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK) then
            dest=0 -- 额外卡组
        else
            dest=1 -- 主卡组
        end
        Duel.SendtoDeck(tc,nil,dest,REASON_EFFECT)
    end
end