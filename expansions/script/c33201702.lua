--圣兽战队 超鹰粉
local cm, m, o = GetID()
function cm.initial_effect(c)
	-- ①效果：掷骰子特召并装备
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m, 1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON + CATEGORY_DICE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1, m)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)

	-- 联合卡限制
	local e21 = Effect.CreateEffect(c)
	e21:SetType(EFFECT_TYPE_SINGLE)
	e21:SetCode(EFFECT_UNION_LIMIT)
	e21:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e21:SetValue(function(e, c)
		return (c:IsControler(e:GetHandlerPlayer())) or e:GetHandler():GetEquipTarget() == c
	end)
	c:RegisterEffect(e21)

	-- ②效果：作为装备或解除装备
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m, 1))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE + LOCATION_SZONE)
	e2:SetCondition(cm.condition)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
end

-- ①效果：掷骰子特召并装备
function cm.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
	local c = e:GetHandler()
	if chk == 0 then
		return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 and
			c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
	end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, c, 1, 0, 0)
	Duel.SetOperationInfo(0, CATEGORY_DICE, nil, 0, tp, 1)
end

function cm.spop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	-- 掷骰子
	local dice = Duel.TossDice(tp, 1)
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP) > 0 then
		-- 确定装备目标区域（逆时针计算）
		if dice < 1 or dice > 6 then return end
		local p = tp
		--(逆时针计算时，seq大于4时，需要绕一圈，顺时针计算时，seq小于0时，也需要绕一圈)
		local seq = c:GetSequence() + dice --逆时针为+，顺时针为-
		while seq > 4 do
			seq = seq - 5
			p = 1 - p
		end
		local tc = Duel.GetFieldCard(p, LOCATION_MZONE, seq)

		-- for _, player in ipairs({ tp, 1 - tp }) do
		--	 for seq = 0, 4 do
		--		 local tc = Duel.GetFieldCard(player, LOCATION_MZONE, seq)
		--		 if tc then
		--			 -- 计算从c来看的逆时针位置
		--			 local relativePos
		--			 if player == tp then -- 自己场上
		--				 relativePos = (seq - c:GetSequence() + 5) % 5
		--			 else				 -- 对方场上
		--				 relativePos = (c:GetSequence() - seq + 5) % 5
		--			 end
		--			 if relativePos + 1 == dice then -- 从下1区开始算1-6
		--				 g:AddCard(tc)
		--			 end
		--		 end
		--	 end
		-- end

		-- 将找到的怪兽装备给这张卡
		if tc and (tc:IsControler(tp) or dice==1 or dice==2) and Duel.SelectYesNo(tp, aux.Stringid(m, 3)) then
			Duel.Equip(tp, tc, c, false)
			-- 装备状态维持
			local e1 = Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(function(e, c)
				return e:GetOwner() == c
			end)
			e1:SetReset(RESET_EVENT + RESETS_STANDARD)
			tc:RegisterEffect(e1)

			-- 将这张卡视为装备魔法卡
			local e2 = Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
			e2:SetCode(EFFECT_CHANGE_TYPE)
			e2:SetValue(TYPE_EQUIP + TYPE_SPELL)
			e2:SetReset(RESET_EVENT + RESETS_STANDARD)
			tc:RegisterEffect(e2)
		end
	end
end

-- ②效果条件：卡的效果发动时
function cm.condition(e, tp, eg, ep, ev, re, r, rp)
	return re:IsActiveType(TYPE_MONSTER + TYPE_SPELL + TYPE_TRAP)
end

function cm.target(e, tp, eg, ep, ev, re, r, rp, chk)
	local c = e:GetHandler()
	local b1 = c:IsLocation(LOCATION_MZONE) and Duel.IsExistingMatchingCard(nil, tp, LOCATION_MZONE, 0, 1, c)
	local b2 = c:IsLocation(LOCATION_SZONE) and Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 and
		c:IsCanBeSpecialSummoned(e, 0, tp, false, false)

	if chk == 0 then
		return (b1 or b2) and c:GetFlagEffect(FLAG_ID_UNION) == 0
	end
	c:RegisterFlagEffect(FLAG_ID_UNION, RESET_EVENT + 0x7e0000 + RESET_PHASE + PHASE_END, 0, 1)

	local ops = {}
	local opval = {}
	if b1 then
		table.insert(ops, aux.Stringid(m, 0))
		table.insert(opval, 0)
	end
	if b2 then
		table.insert(ops, aux.Stringid(m, 1))
		table.insert(opval, 1)
	end

	local opt = Duel.SelectOption(tp, table.unpack(ops))
	e:SetLabel(opval[opt + 1])

	if e:GetLabel() == 0 then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_EQUIP)
		local g = Duel.SelectMatchingCard(tp, Card.IsFaceup, tp, LOCATION_MZONE, 0, 1, 1, c)
		Duel.SetTargetCard(g)
		Duel.SetOperationInfo(0, CATEGORY_EQUIP, g, 1, 0, 0)
	else
		Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, c, 1, 0, 0)
		local mg = Duel.GetMatchingGroup(Card.IsType, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, nil, TYPE_SPELL + TYPE_TRAP)
		if #mg > 0 then
			Duel.SetOperationInfo(0, CATEGORY_DESTROY, mg, 1, 0, 0)
		end
	end
end

function cm.operation(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()

	if e:GetLabel() == 0 then
		-- 作为装备卡装备
		if c:IsRelateToEffect(e) and c:IsLocation(LOCATION_MZONE) then
			local tc = Duel.GetFirstTarget()
			if tc and tc:IsRelateToEffect(e) and tc:IsLocation(LOCATION_MZONE) and tc:IsControler(tp) and tc:IsFaceup() then
				if not Duel.Equip(tp, c, tc, false) then return end
				Auxiliary.SetUnionState(c)

				-- 装备效果：代替破坏
				local e3 = Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_EQUIP)
				e3:SetCode(EFFECT_DESTROY_SUBSTITUTE)
				e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
				e3:SetReset(RESET_EVENT + RESETS_STANDARD)
				e3:SetValue(cm.subval)
				c:RegisterEffect(e3)
			end
		end
	else
		-- 装备状态特殊召唤并破坏魔法陷阱
		if c:IsRelateToEffect(e) and c:IsLocation(LOCATION_SZONE) then
			if Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP) > 0 then
				if Duel.IsExistingMatchingCard(Card.IsType, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, 1, nil, TYPE_SPELL + TYPE_TRAP) and Duel.SelectYesNo(tp, aux.Stringid(m, 2)) then
					Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DESTROY)
					local g = Duel.SelectMatchingCard(tp, Card.IsType, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, 1, 1, nil,
						TYPE_SPELL + TYPE_TRAP)
					if #g > 0 then
						Duel.HintSelection(g)
						Duel.Destroy(g, REASON_EFFECT)
					end
				end
			end
		end
	end
end

-- 装备时的代替破坏效果
function cm.subval(e, re, r, rp)
	return r & REASON_BATTLE + REASON_EFFECT ~= 0
end
