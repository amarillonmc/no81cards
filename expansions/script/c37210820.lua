local s,id=GetID()
function s.initial_effect(c)
	-- 超量召唤规则
	c:EnableReviveLimit()
	-- 使用你指定的 LevelFree 接口，并绑定 mfilter 进行素材判断
	aux.AddXyzProcedureLevelFree(c,s.mfilter,nil,2,2)
	
	-- ①：攻击力上升（连续效果，不入连锁）
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(s.atkop)
	c:RegisterEffect(e1)
	
	-- ②：炸怪（二速诱发即时效果）
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,id)
	e2:SetCost(s.descost)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
end

-- 【超量素材条件过滤】
function s.mfilter(c,xyzc)
	-- 正常情况要求 8 星，或者是由额外卡组特召的水属性怪兽（当作8星处理）
	return c:IsXyzLevel(xyzc,8) or (c:IsAttribute(ATTRIBUTE_WATER) and c:IsSummonLocation(LOCATION_EXTRA))
end

-- 【①效果：处理】
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	-- 仅限怪兽效果或魔法卡效果的发动
	if not (re:IsActiveType(TYPE_MONSTER) or re:IsActiveType(TYPE_SPELL)) then return end
	-- 如果攻击力已经达到或超过4000，则不处理
	if c:GetAttack()>=4000 then return end
	
	local val=100
 	   -- 如果加上100后超过4000，则只上升补足到4000的差值
	if c:GetAttack()+100>4000 then 
		val=4000-c:GetAttack() 
	end
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(val)
	-- 重置条件为离场或被无效时
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e1)
end

-- 【②效果：Cost】
function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end

-- 【②效果：破坏目标过滤】
function s.desfilter(c,atk)
	return c:IsFaceup() and c:GetAttack()<=atk
end

-- 【②效果：发动确认】
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	-- 确认场上是否有攻击力小于等于此卡且表侧表示的怪兽（排除自己）
	if chk==0 then return Duel.IsExistingMatchingCard(s.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,c:GetAttack()) end
	local g=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,c,c:GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end

-- 【②效果：处理】
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	-- 如果自己离场或者被盖放（无法判定攻击力），则不处理
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local atk=c:GetAttack()
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	-- 不取对象，在处理时选择最多2只
	local g=Duel.SelectMatchingCard(tp,s.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,2,c,atk)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end