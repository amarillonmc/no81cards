--巡猎蜂群 卫戍兵蜂
local s, id = GetID()
local SET_PATROL_BEE = 0xc328

function s.initial_effect(c)
	-- ①：出场贴卡
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1, id) -- 卡名硬限制
	e1:SetTarget(s.tftg)
	e1:SetOperation(s.tfop)
	c:RegisterEffect(e1)
	
	local e2 = e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)

	--get effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(s.givecon)
	e3:SetOperation(s.giveop)
	c:RegisterEffect(e3)
end

-- ===========================
-- 效果①：卡组贴P/永续
-- ===========================

function s.tffilter(c)
	return c:IsSetCard(SET_PATROL_BEE) 
		and c:IsType(TYPE_MONSTER) 
		and not c:IsCode(id) -- 排除自身
		and not c:IsForbidden()
end

function s.tftg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.GetLocationCount(tp, LOCATION_SZONE) > 0
		and Duel.IsExistingMatchingCard(s.tffilter, tp, LOCATION_DECK, 0, 1, nil) end
end

function s.tfop(e, tp, eg, ep, ev, re, r, rp)
	if Duel.GetLocationCount(tp, LOCATION_SZONE) <= 0 then return end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOFIELD)
	local g = Duel.SelectMatchingCard(tp, s.tffilter, tp, LOCATION_DECK, 0, 1, 1, nil)
	local tc = g:GetFirst()
	if tc then
		-- 放置到魔陷区
		if Duel.MoveToField(tc, tp, tp, LOCATION_SZONE, POS_FACEUP, true) then
			-- 变为永续魔法
			local e1 = Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT + RESETS_STANDARD - RESET_TURN_SET)
			e1:SetValue(TYPE_SPELL + TYPE_CONTINUOUS)
			tc:RegisterEffect(e1)
		end
	end
end

-- ===========================
-- 效果②：赋予效果逻辑
-- ===========================
-- 检查：是否作为「巡猎蜂」的素材
function s.givecon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	return r==REASON_XYZ and rc:IsSetCard(SET_PATROL_BEE)
end

-- 操作：给那只超量怪兽注册效果
function s.giveop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	
	-- 赋予的效果：无效并破坏
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(id,1)) -- 记得在数据库cdb中加一条描述
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(s.negcon)
	e1:SetCost(s.negcost)
	e1:SetTarget(s.negtg)
	e1:SetOperation(s.negop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
	rc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,1))
	-- 补充：如果怪兽原本不是效果怪兽，加上效果怪兽的类型
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e2,true)
	end
end

-- 【关键部分】判定条件：对方发动 + 涉及场上的（破坏/除外/送墓）
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	-- 1. 必须是对方发动的效果
	if rp==tp or not Duel.IsChainDisablable(ev) then return false end

	-- 2. 检查：是否包含“破坏”且涉及场上
	if re:IsHasCategory(CATEGORY_DESTROY) then
		local ex,tg,tc,p,loc = Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
		-- 情况A：有确定的对象(tg)，且其中有卡在场上
		if tg and tg:IsExists(Card.IsOnField,1,nil) then return true end
		-- 情况B：没有确定对象(如雷击)，但涉及的区域(loc)包含场上
		if loc and (loc & LOCATION_ONFIELD)~=0 then return true end
	end

	-- 3. 检查：是否包含“除外”且涉及场上
	if re:IsHasCategory(CATEGORY_REMOVE) then
		local ex,tg,tc,p,loc = Duel.GetOperationInfo(ev,CATEGORY_REMOVE)
		if tg and tg:IsExists(Card.IsOnField,1,nil) then return true end
		if loc and (loc & LOCATION_ONFIELD)~=0 then return true end
	end

	-- 4. 检查：是否包含“送去墓地”且涉及场上
	if re:IsHasCategory(CATEGORY_TOGRAVE) then
		local ex,tg,tc,p,loc = Duel.GetOperationInfo(ev,CATEGORY_TOGRAVE)
		if tg and tg:IsExists(Card.IsOnField,1,nil) then return true end
		if loc and (loc & LOCATION_ONFIELD)~=0 then return true end
	end

	return false
end

-- Cost：取除2个素材
function s.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end

-- Target：设定要无效和破坏的对象
function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end

-- Operation：执行无效并破坏
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end