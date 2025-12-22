--应答解析
local s, id = GetID()
local SET_REALM_WEAVER = 0xa328

function s.initial_effect(c)
	-- ①：发动效果
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON + CATEGORY_DESTROY + CATEGORY_DISABLE + CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1, id + EFFECT_COUNT_CODE_OATH) -- 卡名1回合1张（硬限制）
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)

	-- 盖放的回合也能发动
	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	c:RegisterEffect(e2)
end

-- 过滤对象：连接状态、电子界族、可被效果解放
function s.tgfilter(c)
	return c:IsLinkState() 
		and c:IsRace(RACE_CYBERSE) 
		and c:IsReleasableByEffect()
end

-- 选项1过滤：界域编织者 + 可特召
function s.spfilter(c, e, tp)
	return c:IsSetCard(SET_REALM_WEAVER) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end

function s.target(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.tgfilter(chkc) end
	if chk == 0 then return Duel.IsExistingTarget(s.tgfilter, tp, LOCATION_MZONE, 0, 1, nil) end
	
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TARGET)
	local g = Duel.SelectTarget(tp, s.tgfilter, tp, LOCATION_MZONE, 0, 1, 1, nil)
	
	-- 判断各选项是否可用
	-- 选项1：卡组有怪，且有空位（注意：解放怪兽会腾出格子，所以主要怪兽区满的情况通常也可以，除非被限制）
	-- 这里为了简化逻辑，通常只要卡组有怪即可，因为处理时会先解放
	local op1 = Duel.IsExistingMatchingCard(s.spfilter, tp, LOCATION_DECK, 0, 1, nil, e, tp)
	-- 选项2：对方场上有卡
	local op2 = Duel.IsExistingMatchingCard(aux.TRUE, tp, 0, LOCATION_ONFIELD, 1, nil)
	-- 选项3：总是可用（即使场上无其他怪兽，效果也能处理，只是加攻数量为0或无对象）
	local op3 = true

	-- 构建选项列表
	local ops = {}
	local opval = {}
	local off = 1
	if op1 then
		ops[off] = aux.Stringid(id, 1) -- "特召"
		opval[off] = 0
		off = off + 1
	end
	if op2 then
		ops[off] = aux.Stringid(id, 2) -- "无效并破坏"
		opval[off] = 1
		off = off + 1
	end
	if op3 then
		ops[off] = aux.Stringid(id, 3) -- "攻击力上升"
		opval[off] = 2
		off = off + 1
	end

	local op = Duel.SelectOption(tp, table.unpack(ops))
	local sel = opval[op + 1]
	e:SetLabel(sel)

	-- 根据选择设置OperationInfo（提示给玩家和AI）
	if sel == 0 then
		Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_DECK)
	elseif sel == 1 then
		Duel.SetOperationInfo(0, CATEGORY_DISABLE, nil, 1, 1-tp, LOCATION_ONFIELD)
		Duel.SetOperationInfo(0, CATEGORY_DESTROY, nil, 1, 1-tp, LOCATION_ONFIELD)
	elseif sel == 2 then
		Duel.SetOperationInfo(0, CATEGORY_ATKCHANGE, nil, 0, tp, LOCATION_MZONE)
	end
end

function s.activate(e, tp, eg, ep, ev, re, r, rp)
	local tc = Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end

	-- 记录原本攻击力 (用于选项3)
	local base_atk = tc:GetBaseAttack()
	if base_atk < 0 then base_atk = 0 end

	-- 必须成功解放才能进行后续
	if Duel.Release(tc, REASON_EFFECT) > 0 then
		local sel = e:GetLabel()
		
		-- ●从卡组选1只「界域编织者」怪兽特殊召唤。
		if sel == 0 then
			if Duel.GetLocationCount(tp, LOCATION_MZONE) <= 0 then return end
			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
			local g = Duel.SelectMatchingCard(tp, s.spfilter, tp, LOCATION_DECK, 0, 1, 1, nil, e, tp)
			if #g > 0 then
				Duel.SpecialSummon(g, 0, tp, tp, false, false, POS_FACEUP)
			end

		-- ●选对方场上1张卡效果无效并破坏。
		elseif sel == 1 then
			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DESTROY)
			-- 注意：文案是“选”，所以是不取对象的
			local g = Duel.SelectMatchingCard(tp, nil, tp, 0, LOCATION_ONFIELD, 1, 1, nil)
			if #g > 0 then
				local des_tc = g:GetFirst()
				-- 先无效
				if not des_tc:IsDisabled() then
					Duel.NegateRelatedChain(des_tc, RESET_TURN_SET)
					local e1 = Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_DISABLE)
					e1:SetReset(RESET_EVENT + RESETS_STANDARD)
					des_tc:RegisterEffect(e1)
					local e2 = Effect.CreateEffect(e:GetHandler())
					e2:SetType(EFFECT_TYPE_SINGLE)
					e2:SetCode(EFFECT_DISABLE_EFFECT)
					e2:SetValue(RESET_TURN_SET)
					e2:SetReset(RESET_EVENT + RESETS_STANDARD)
					des_tc:RegisterEffect(e2)
					-- 对于陷阱怪兽等情况可能需要更多处理，但通用无效破坏这样已足够
				end
				-- 再破坏
				Duel.AdjustInstantly(des_tc) -- 刷新状态
				Duel.Destroy(des_tc, REASON_EFFECT)
			end

		-- ●这个回合自己场上的怪兽攻击力上升那个解放怪兽的原本攻击力数值。
		elseif sel == 2 then
			local g = Duel.GetMatchingGroup(Card.IsFaceup, tp, LOCATION_MZONE, 0, nil)
			local tc_buff = g:GetFirst()
			for tc_buff in aux.Next(g) do
				local e1 = Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetValue(base_atk)
				e1:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_END)
				tc_buff:RegisterEffect(e1)
			end
		end
	end
end
