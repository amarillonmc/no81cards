--炽魂·铁壁 豪鬼
local s, id = GetID()

-- 定义炽魂字段常量
s.soul_setcode = 0xa96c

function s.initial_effect(c)
	
	-- 允许放置炽魂指示物
	c:EnableCounterPermit(s.soul_setcode)
	
	-- 效果①：特殊召唤规则（自己场上有炽魂指示物时可以从手卡特殊召唤）
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP,0)
	e1:SetCondition(s.spcon)
	e1:SetValue(SUMMON_VALUE_SELF)
	c:RegisterEffect(e1)
	
	-- 效果②：特殊召唤或攻击宣言时放置指示物
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(s.ctcon1)
	e2:SetTarget(s.cttg)
	e2:SetOperation(s.ctop)
	c:RegisterEffect(e2)
	
	local e3=e2:Clone()
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetCondition(s.ctcon2)
	c:RegisterEffect(e3)
	
	-- 效果③：无效对方效果发动
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,id)
	e4:SetCondition(s.negcon)
	e4:SetCost(s.negcost)
	e4:SetTarget(s.negtg)
	e4:SetOperation(s.negop)
	c:RegisterEffect(e4)
end

-- 效果①：特殊召唤条件（自己场上有炽魂指示物）
function s.spfilter(c)
	return c:GetCounter(s.soul_setcode)>0
end

function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_ONFIELD,0,1,nil)
end

-- 效果②：放置指示物条件1（特殊召唤成功时）
function s.ctcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFaceup()
end

-- 效果②：放置指示物条件2（攻击宣言时）
function s.ctcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup() and c==Duel.GetAttacker()
end

function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,s.soul_setcode)
end

function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		c:AddCounter(s.soul_setcode,1)
	end
end

-- 效果③：无效效果的条件（对方效果发动时）
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep~=tp and re:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
		and Duel.IsChainNegatable(ev)
end

-- 效果③：去除指示物作为代价
function s.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,s.soul_setcode,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,s.soul_setcode,1,REASON_COST)
end

-- 效果③：无效效果的目标设定
function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	-- 检查是否有炽魂速攻魔法卡
	local g=Duel.GetMatchingGroup(s.quickfilter,tp,LOCATION_SZONE,0,nil)
	if #g>0 and re:GetHandler():IsDestructable() then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end

-- 检查场上有表侧表示的炽魂速攻魔法卡
function s.quickfilter(c)
	return c:IsFaceup() and c:IsSetCard(s.soul_setcode) and c:IsType(TYPE_QUICKPLAY)
end

-- 效果③：无效效果的操作
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	
	-- 无效效果发动
	if Duel.NegateActivation(ev) then
		-- 检查是否有炽魂速攻魔法卡
		local g=Duel.GetMatchingGroup(s.quickfilter,tp,LOCATION_SZONE,0,nil)
		if #g>0 and rc and rc:IsRelateToEffect(re) and rc:IsDestructable() then
			Duel.Destroy(rc,REASON_EFFECT)
		end
	end
end