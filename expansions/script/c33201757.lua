--数据溢出
local s, id = GetID()
local SET_REALM_WEAVER = 0xa328

function s.initial_effect(c)
	-- ①：全场破坏 + 条件性无效
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1, id) -- 与效果②共用1回合1次的限制
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)

	-- ②：墓地除外检索额外卡组
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1, id) -- 与效果①共用1回合1次的限制
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end

-- ===========================
-- 效果①：破坏与无效
-- ===========================

-- 过滤非连接状态的怪兽
function s.desfilter(c)
	return not c:IsLinkState()
end

function s.destg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(s.desfilter, tp, LOCATION_MZONE, LOCATION_MZONE, 1, nil) end
	local g = Duel.GetMatchingGroup(s.desfilter, tp, LOCATION_MZONE, LOCATION_MZONE, nil)
	Duel.SetOperationInfo(0, CATEGORY_DESTROY, g, #g, 0, 0)
end

function s.desop(e, tp, eg, ep, ev, re, r, rp)
	local g = Duel.GetMatchingGroup(s.desfilter, tp, LOCATION_MZONE, LOCATION_MZONE, nil)
	if #g > 0 then
		-- 执行破坏
		local ct = Duel.Destroy(g, REASON_EFFECT)
		
		-- 破坏成功 且 自己场上连接状态怪兽>=3 时，处理无效效果
		if ct > 0 and Duel.GetMatchingGroupCount(Card.IsLinkState, tp, LOCATION_MZONE, 0, nil) >= 3 then
			-- 获取刚才被破坏的那些卡
			local og = Duel.GetOperatedGroup()
			local c = e:GetHandler()
			
			-- 遍历被破坏的卡，封印其卡名
			for tc in aux.Next(og) do
				local code = tc:GetOriginalCode()
				-- 注册全局无效效果
				-- 1. 场上无效 (Effect Disable)
				local e1 = Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetTargetRange(LOCATION_MZONE, LOCATION_MZONE)
				e1:SetTarget(s.distg)
				e1:SetLabel(code) -- 记录被破坏怪兽的卡名
				e1:SetReset(RESET_PHASE + PHASE_END, 2) -- 直到下个回合结束时
				Duel.RegisterEffect(e1, tp)

				-- 2. 发动无效 (Disable Effect) - 包含场上和墓地发动的效果
				local e2 = Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
				e2:SetCode(EVENT_CHAIN_SOLVING)
				e2:SetCondition(s.discon)
				e2:SetOperation(s.disop)
				e2:SetLabel(code)
				e2:SetReset(RESET_PHASE + PHASE_END, 2)
				Duel.RegisterEffect(e2, tp)
				
				-- 注意：如果是想完全封锁（类似指名者），通常还需要封印手卡/墓地发动的效果不被处理。
				-- 上面的写法主要针对场上怪兽效果无效化。
				-- 若要严格对应文案“那些怪兽以及原本卡名相同的怪兽的效果无效化”，
				-- 通常采用 Field Disable + Chain Solving Disable 组合。
			end
		end
	end
end

-- 场上无效过滤
function s.distg(e, c)
	return c:IsOriginalCodeRule(e:GetLabel())
end

-- 连锁处理时无效判定
function s.discon(e, tp, eg, ep, ev, re, r, rp)
	-- 只有怪兽效果受影响，且卡名匹配
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsOriginalCodeRule(e:GetLabel())
end

-- 连锁处理时无效操作
function s.disop(e, tp, eg, ep, ev, re, r, rp)
	Duel.NegateEffect(ev)
end

-- ===========================
-- 效果②：检索
-- ===========================

-- 过滤：界域编织者、灵摆、额外表侧、可拿回手卡
function s.thfilter(c)
	return c:IsSetCard(SET_REALM_WEAVER) 
		and c:IsType(TYPE_PENDULUM) 
		and c:IsFaceup() -- 【重点】使用 IsFaceup
		and c:IsAbleToHand()
end

function s.thtg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(s.thfilter, tp, LOCATION_EXTRA, 0, 1, nil) end
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_EXTRA)
end

function s.thop(e, tp, eg, ep, ev, re, r, rp)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
	local g = Duel.SelectMatchingCard(tp, s.thfilter, tp, LOCATION_EXTRA, 0, 1, 1, nil)
	if #g > 0 then
		Duel.SendtoHand(g, nil, REASON_EFFECT)
		Duel.ConfirmCards(1-tp, g)
	end
end