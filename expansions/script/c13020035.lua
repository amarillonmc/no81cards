--在水中央
local cm, m, ofs = GetID()
local yr = 13020010
xpcall(function() dofile("expansions/script/c16670000.lua") end, function() dofile("script/c16670000.lua") end) --引用库
function cm.initial_effect(c)
	aux.AddCodeList(c, yr)
	aux.AddEquipSpellEffect(c, true, true, Card.IsFaceup, nil)

	local e3 = Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_ATTACK_ALL)
	e3:SetValue(1)
	local e33 = Effect.CreateEffect(c)
	e33:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_GRANT)
	e33:SetRange(LOCATION_SZONE)
	e33:SetTargetRange(LOCATION_MZONE, 0)
	e33:SetTarget(cm.eftg)
	e33:SetLabelObject(e3)
	c:RegisterEffect(e33)

	-- local e4 = Effect.CreateEffect(c)
	-- e4:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
	-- e4:SetCode(EVENT_LEAVE_FIELD_P)
	-- e4:SetRange(LOCATION_SZONE)
	-- e4:SetOperation(cm.damp)
	-- c:RegisterEffect(e4)
	local e5 = Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCode(EFFECT_SEND_REPLACE)
	e5:SetTarget(cm.reptg)
	e5:SetOperation(cm.repop)
	e5:SetValue(cm.repval)
	c:RegisterEffect(e5)

	local e1 = xg.epp2(c, m, 4, EVENT_LEAVE_FIELD, EFFECT_FLAG_DAMAGE_STEP + EFFECT_FLAG_DELAY, QY_sk, nil, nil,
		cm.target,
		cm.operation, true)
	e1:SetCountLimit(1, m)
	local e2 = e1:Clone()
	e2:SetRange(QY_md)
	c:RegisterEffect(e2)

	if not cm.global_check then
		cm.global_check = true
		local e4 = Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_CONTINUOUS + EFFECT_TYPE_FIELD)
		e4:SetCode(EVENT_ADJUST)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_IGNORE_IMMUNE)
		e4:SetOperation(cm.adop)
		Duel.RegisterEffect(e4, tp)
	end
end

function cm.eftg(e, c)
	return c == e:GetHandler():GetEquipTarget()
end

function cm.filter(c, tc, bc, tp)
	-- Duel.ConfirmCards(tp, c)
	-- Debug.Message(c:IsReason(REASON_BATTLE) and c:IsType(TYPE_MONSTER) and c:GetReasonCard() == tc)
	-- Debug.Message(c:GetReasonCard() == tc)
	--return c:IsReason(REASON_BATTLE) and c:IsType(TYPE_MONSTER) and c:GetReasonCard() == tc --and bc and bc == c --
	return c:IsReason(REASON_BATTLE) and c:IsType(TYPE_MONSTER) and c:GetReasonCard() == tc
end

function cm.eqlimit(e, c)
	return e:GetOwner() == c
end

function cm.damp(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler():GetEquipTarget()
	local bc = c:GetBattleTarget()
	local g = eg:Filter(cm.filter, nil, c, bc, tp)
	-- Debug.Message(#g)
	if #g == 0 then return end
	for tc in aux.Next(g) do
		if Duel.GetLocationCount(tp, LOCATION_SZONE) > 0 then
			-- Duel.MoveToField(tc, tp, tp, LOCATION_SZONE, POS_FACEUP, true)
			Duel.Equip(tp, tc, c, false)
			tc:CancelToGrave()
			local e1 = Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT + RESETS_STANDARD)
			e1:SetValue(cm.eqlimit)
			tc:RegisterEffect(e1)
			local e2 = Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_EQUIP)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetReset(RESET_EVENT + RESETS_STANDARD)
			e2:SetValue(300)
			tc:RegisterEffect(e2)
		end
	end
end

function cm.reptg(e, tp, eg, ep, ev, re, r, rp, chk)
	local c = e:GetHandler():GetEquipTarget()
	if not c then return end
	local bc = c:GetBattleTarget()
	-- Duel.ConfirmCards(tp, bc)
	-- Debug.Message(#eg)
	if chk == 0 then return eg:IsExists(cm.filter, 1, nil, c, bc) end
	-- e:strLabelObject(eg)
	return true
end

function cm.repop(e, tp, eg, ep, ev, re, r, rp, chk)
	local c = e:GetHandler():GetEquipTarget()
	local tp = c:GetControler()
	local tc = c:GetBattleTarget()
	if not tc then return end
	if Duel.GetLocationCount(tp, LOCATION_SZONE) > 0 then
		-- Duel.MoveToField(tc, tp, tp, LOCATION_SZONE, POS_FACEUP, true)
		Duel.Equip(tp, tc, c, false)
		tc:CancelToGrave()
		local e1 = Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT + RESETS_STANDARD)
		e1:SetValue(cm.eqlimit)
		tc:RegisterEffect(e1)
		local e2 = Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetReset(RESET_EVENT + RESETS_STANDARD)
		e2:SetValue(300)
		tc:RegisterEffect(e2)
	end
end

function cm.repval(e, c)
	local tc = c:GetBattleTarget()
	return cm.filter(c, tc) --cm.repfilter(c, e:GetHandlerPlayer())
end

function cm.costfilter(c)
	return c:IsDiscardable()
end

function cm.Cost(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	local c = e:GetHandler()
	if chk == 0 then return Duel.IsExistingMatchingCard(cm.costfilter, tp, LOCATION_HAND, 0, 1, e:GetHandler()) end
	Duel.DiscardHand(tp, cm.costfilter, 1, 1, REASON_COST + REASON_DISCARD)
end

function cm.repfilter(c, tp)
	return c:IsType(TYPE_UNION) or c:IsType(TYPE_EQUIP)
end

function cm.repfilter2(c, tp, tc)
	return c:IsType(TYPE_UNION) or c:IsType(TYPE_EQUIP) and tc:CheckEquipTarget(c)
end

function cm.target(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	local c = e:GetHandler()
	local kx, zzx, sxx, zzjc, sxjc, zzl = it.sxbl()
	local g1 = eg:Filter(cm.repfilter, nil, tp)
	if chk == 0 then return zzx > 0 and #g1 > 0 and not eg:IsContains(c) end
	local zz, sx, lv = it.sxblx(tp, kx, zzx, sxx, zzl)
	e:SetLabel(zz, sx, lv)
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, c, 1, 0, 0)
end

function cm.operation(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local zz, sx, lv = e:GetLabel()
	if not Duel.IsPlayerCanSpecialSummonMonster(tp, c:GetCode(), 0, TYPE_NORMAL + TYPE_MONSTER + TYPE_TUNER, 0, 0, lv, zz, sx) then return end
	it.AddMonsterate(c, TYPE_NORMAL + TYPE_MONSTER, sx, zz, lv, 0, 0)
	Duel.SpecialSummonStep(c, 0, tp, tp, true, false, POS_FACEUP_DEFENSE)
	Duel.SpecialSummonComplete()

	local g1 = eg:Filter(cm.repfilter2, nil, tp, c)
	if #g1 > 0 then
		for tc in aux.Next(g1) do
			if Duel.GetLocationCount(tp, LOCATION_SZONE) > 0 then
				if Duel.Equip(tp, tc, c) and aux.IsCodeListed(tc, yr) and Duel.SelectYesNo(tp, aux.Stringid(m, 0)) then
					local te = cm[tc]
					if te then
						for _, ie in ipairs(te) do
							Duel.BreakEffect()
							local tg = ie:GetTarget()
							if tg and tg(ie, tp, eg, ep, ev, re, r, rp, 0) then
								local op = ie:GetOperation()
								if op then
									tg(ie, tp, eg, ep, ev, re, r, rp, 1)
									op(ie, tp, eg, ep, ev, re, r, rp)
								end
							end
						end
					end
				end
				-- local e1 = Effect.CreateEffect(c)
				-- e1:SetType(EFFECT_TYPE_SINGLE)
				-- e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
				-- e1:SetCode(EFFECT_EQUIP_LIMIT)
				-- e1:SetReset(RESET_EVENT + RESETS_STANDARD)
				-- e1:SetValue(cm.eqlimit)
				-- tc:RegisterEffect(e1)
			end
		end
	end
end

function cm.adop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local ng = Duel.GetMatchingGroup(cm.filsn, tp, LOCATION_HAND + LOCATION_ONFIELD + LOCATION_GRAVE + QY_kz, 0, c)
	local nc = ng:GetFirst()
	while nc do
		if not cm.reg then
			cm.reg = Card.RegisterEffect
			Card.RegisterEffect = cm.reg2
		end
		nc:RegisterFlagEffect(m, 0, 0, 1)
		nc:ReplaceEffect(nc:GetOriginalCodeRule(), 0)
		-- Card.RegisterEffect = cm.reg
		nc = ng:GetNext()
	end
end

function cm.filsn(c)
	return aux.IsCodeListed(c, yr) and c:IsType(TYPE_EQUIP) and c:GetFlagEffect(m) == 0
		and not c:IsOriginalCodeRule(m)
end

function cm.reg2(c, ie, ob)
	local b = ob or false
	local p = ie:GetCode()
	if not aux.IsCodeListed(c, yr) or p ~= EVENT_EQUIP then
		return cm.reg(c, ie, b)
	end
	if p == EVENT_EQUIP then
		cm[c] = cm[c] or {}
		cm[c][#cm[c] + 1] = ie
	end
	return cm.reg(c, ie, b)
end
