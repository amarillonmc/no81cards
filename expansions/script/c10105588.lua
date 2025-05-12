function c10105588.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,10105588)
	e1:SetCondition(c10105588.condition)
	e1:SetTarget(c10105588.target)
	e1:SetOperation(c10105588.activate)
	c:RegisterEffect(e1)
    -- ②效果：攻击宣言时从墓地发动
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_ATTACK_ANNOUNCE) -- 对方攻击宣言时
    e2:SetRange(LOCATION_GRAVE)       -- 在墓地发动
	e2:SetCountLimit(1,101055880)
    e2:SetCost(aux.bfgcost)            -- 自身除外作为cost
    e2:SetTarget(c10105588.sptg)
    e2:SetOperation(c10105588.spop)
    c:RegisterEffect(e2)
end
function c10105588.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x7cca)
end
function c10105588.condition(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c10105588.cfilter,tp,LOCATION_MZONE,0,1,nil) then return false end
	if not Duel.IsChainNegatable(ev) then return false end
	return re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c10105588.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c10105588.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end

-- 修正后的筛选函数（添加 e,tp 参数）
function c10105588.spfilter(c,e,tp)
    return c:GetLevel()==12 
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end

-- 修正后的目标选择
function c10105588.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then 
        return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
            and Duel.IsExistingMatchingCard(c10105588.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp)
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c10105588.spfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
    if #g>0 then
        Duel.SetTargetCard(g:GetFirst())
        Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
    end
end

-- 效果处理：特殊召唤
function c10105588.spop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end