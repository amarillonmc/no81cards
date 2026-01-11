local s, id = GetID()
local SET_PATROL_BEE = 0xc328

function s.initial_effect(c)
	-- 发动（开连锁的永续魔法通常只需要注册Activate，具体效果写在后面，
	-- 但如果该卡发动时没有效果处理，直接注册为ACTIVATE + FREE_CHAIN即可）
	local e0 = Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)

	-- ①：控顶 + 无效 + 塞素材
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1, id) -- 硬限制
	e1:SetTarget(s.distg)
	e1:SetOperation(s.disop)
	c:RegisterEffect(e1)

	-- ②：攻击力上升
	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE, 0)
	e2:SetTarget(s.atktg)
	e2:SetValue(s.atkval)
	c:RegisterEffect(e2)
end

-- ===========================
-- 效果①：控顶 + 无效 + 塞素材
-- ===========================

-- 过滤需要被无效的卡：除自身以外的表侧表示卡
function s.disfilter(c)
	return c:IsFaceup() and not c:IsCode(id)
end

-- 过滤卡组中的「巡猎蜂」怪兽
function s.tdfilter(c)
	return c:IsSetCard(SET_PATROL_BEE) and c:IsType(TYPE_MONSTER)
end

-- 过滤自己的昆虫族超量怪兽
function s.xyzfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_INSECT) and c:IsType(TYPE_XYZ)
end

function s.distg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chkc then return chkc:IsOnField() and s.disfilter(chkc) end
	if chk == 0 then return Duel.IsExistingTarget(s.disfilter, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, 1, e:GetHandler())
		and Duel.IsExistingMatchingCard(s.tdfilter, tp, LOCATION_DECK, 0, 1, nil) end
	
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_FACEUP)
	local g = Duel.SelectTarget(tp, s.disfilter, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, 1, 1, e:GetHandler())
	Duel.SetOperationInfo(0, CATEGORY_DISABLE, g, 1, 0, 0)
end

function s.disop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	
	-- 步骤1：从卡组把1只「巡猎蜂」怪兽在自己卡组最上面放置
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_OPERATECARD)
	local g = Duel.SelectMatchingCard(tp, s.tdfilter, tp, LOCATION_DECK, 0, 1, 1, nil)
	if #g > 0 then
		local tc = g:GetFirst()
		-- 这里的标准操作是：先洗切卡组，再把那张卡放回最上面
		Duel.ShuffleDeck(tp)
		Duel.MoveSequence(tc, 0) -- 0 通常代表 Deck Top
		Duel.ConfirmDecktop(tp, 1) -- 习惯性确认一下（可选）
		
		-- 步骤2：作为对象的卡的效果无效
		-- 文案逻辑：“放置，...无效”。这通常视为同时处理或不分先后。
		local target = Duel.GetFirstTarget()
		if target:IsRelateToEffect(e) and target:IsFaceup() and not target:IsDisabled() then
			
			Duel.NegateRelatedChain(target, RESET_TURN_SET)
			
			local e1 = Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_END)
			target:RegisterEffect(e1)
			
			local e2 = Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_END)
			target:RegisterEffect(e2)
			
			if target:IsType(TYPE_TRAPMONSTER) then
				local e3 = Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
				e3:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_END)
				target:RegisterEffect(e3)
			end
			
			-- 步骤3：那之后，可以塞素材
			-- 只有成功无效了，才能处理“那之后”
			if target:IsRelateToEffect(e) and not target:IsImmuneToEffect(e) and tc:IsCanOverlay() then 
				Duel.BreakEffect()
				local og=target:GetOverlayGroup()
				if og:GetCount()>0 then
					Duel.SendtoGrave(og,REASON_RULE)
				end
				Duel.Overlay(c,Group.FromCards(target))
			end
		end
	end
end

-- ===========================
-- 效果②：攻击力上升
-- ===========================

function s.atktg(e, c)
	return c:IsRace(RACE_INSECT) and (c:IsLevel(3) or c:IsLevel(5))
end

function s.atkval(e, c)
	-- 计算自己场上所有超量素材的数量
	local tp = e:GetHandlerPlayer()
	local g = Duel.GetMatchingGroup(Card.IsType, tp, LOCATION_MZONE, 0, nil, TYPE_XYZ)
	local ct = 0
	for tc in aux.Next(g) do
		ct = ct + tc:GetOverlayCount()
	end
	return ct * 500
end