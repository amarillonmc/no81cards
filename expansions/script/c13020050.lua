--武器大师 天天
local cm, m, o = GetID()
function cm.initial_effect(c)
	-- 设置同调怪兽苏生限制
	c:EnableReviveLimit()

	-- 设置同调召唤条件：有装备卡装备的调整+调整以外的怪兽1只以上
	aux.AddSynchroProcedure(c, function(tuner, scard)
		return tuner:IsType(TYPE_TUNER) and tuner:GetEquipCount() > 0
	end, aux.NonTuner(nil), 1)

	-- 这个卡名的①的效果1回合可以使用2次
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m, 0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1, m)
	e1:SetCondition(cm.thcon)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	local e2 = e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)

	local e3 = Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(m)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(1, 0)
	c:RegisterEffect(e3)

	-- ②：只要这张卡在场上存在，自己可以在对方回合把装备魔法卡发动
	-- local e4 = Effect.CreateEffect(c)
	-- e4:SetType(EFFECT_TYPE_FIELD)
	-- e4:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	-- e4:SetTargetRange(LOCATION_HAND, 0)
	-- e4:SetCondition(cm.actcon)
	-- e4:SetTarget(function(e, tc) return tc:IsType(TYPE_EQUIP) end)
	-- Duel.RegisterEffect(e4, tp)

	if not cm.gall then
		cm.gall = true
		cm.global_jc = {}
		--
		local l = Effect.IsHasType
		Effect.IsHasType = function(ea, le)
			if ea:GetLabel() == m then return true end
			for z, v in pairs(cm.global_jc) do
				for i = 1, #v do
					if v[i] == ea and le == EFFECT_TYPE_ACTIVATE then
						return true
					end
				end
			end
			return l(ea, le)
		end
		local l2 = Card.GetActivateEffect
		Card.GetActivateEffect = function(c)
			local ob = { l2(c) }
			for z, v in pairs(cm.global_jc) do --表名，表内容
				if z == c then
					for i = 1, #v do
						ob[#ob + 1] = v[i]
					end
				end
			end
			return table.unpack(ob)
		end
		local l3 = Effect.Clone
		Effect.Clone = function(ea)
			local qe = l3(ea)
			if ea:GetLabel() == m then
				-- cm.global_jc[z][#cm.global_jc[z] + 1] = qe
				return qe
			end
			for z, v in pairs(cm.global_jc) do
				for i = 1, #v do
					if v[i] == ea then
						cm.global_jc[z][#cm.global_jc[z] + 1] = qe
						return qe
					end
				end
			end
			return qe
		end
		--模拟魔法
		local ge13 = Effect.CreateEffect(c)
		ge13:SetType(EFFECT_TYPE_FIELD)
		ge13:SetCode(EFFECT_ACTIVATE_COST)
		ge13:SetTargetRange(1, 1)
		ge13:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		ge13:SetTarget(cm.actarget)
		ge13:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge13, 0)
		-- 为手里的装备魔法卡重新注册效果并修改条件
		local e5 = Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
		e5:SetCode(EVENT_ADJUST)
		e5:SetOperation(cm.adjustop)
		Duel.RegisterEffect(e5, 0)
	end
end

-- ②效果条件
function cm.actcon(e)
	return e:GetHandler():IsFaceup()
end

-- 为装备魔法卡重新注册效果
function cm.adjustop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local g = Duel.GetMatchingGroup(function(tc)
		return tc:GetFlagEffect(m) == 0
	end, tp, 0xff, 0xff, nil)
	for tc in aux.Next(g) do
		local te = { tc:GetActivateEffect() }
		tc:RegisterFlagEffect(m, 0, 0, 1)
		if tc:IsType(TYPE_EQUIP) and #te > 0 then
			-- 重新注册效果并修改条件
			for _, ie in ipairs(te) do
				-- local ie = ie0:Clone()
				if ie:GetType() & EFFECT_TYPE_ACTIVATE ~= 0 and ie:GetCode() & EVENT_FREE_CHAIN ~= 0 then
					-- local ied, ied2 = ie:GetProperty()
					local qe = ie:Clone()
					local de = ie:GetDescription()
					if not de then
						qe:SetDescription(aux.Stringid(m, 1))
					end
					qe:SetType(EFFECT_TYPE_QUICK_O)
					qe:SetCode(EVENT_FREE_CHAIN)
					-- qe:SetProperty(ied, ied2|EFFECT_FLAG2_COF)
					-- qe:SetTarget(ie:GetTarget())
					-- qe:SetOperation(ie:GetOperation())
					qe:SetRange(LOCATION_HAND)

					-- 修改条件，增加受此卡效果影响的判断
					local con = ie:GetCondition()
					qe:SetCondition(function(e, tp, eg, ep, ev, re, r, rp)
						return Duel.IsPlayerAffectedByEffect(tp, m) and
							(not con or con(e, tp, eg, ep, ev, re, r, rp))
					end)

					cm.global_jc[tc] = cm.global_jc[tc] or {}
					cm.global_jc[tc][#cm.global_jc[tc] + 1] = qe
					tc:RegisterEffect(qe)
					ie:SetCondition(function(e, tp, eg, ep, ev, re, r, rp)
						return Duel.IsPlayerAffectedByEffect(tp, m) == nil and
							(not con or con(e, tp, eg, ep, ev, re, r, rp))
					end)
				end
			end
		else
			local l = Card.RegisterEffect
			Card.RegisterEffect = function(c, effect, ...)
				if effect:GetType() & EFFECT_TYPE_GRANT ~= 0 then
					local e2 = effect:GetLabelObject()
					if e2:GetType() & EFFECT_TYPE_ACTIVATE ~= 0 and e2:GetCode() & EVENT_FREE_CHAIN ~= 0 then
						local qe = e2:Clone()
						local de = e2:GetDescription()
						if not de then
							qe:SetDescription(aux.Stringid(m, 1))
						end
						qe:SetType(EFFECT_TYPE_QUICK_O)
						qe:SetCode(EVENT_FREE_CHAIN)
						qe:SetRange(LOCATION_HAND)
						qe:SetLabel(m)
						local con = e2:GetCondition()
						qe:SetCondition(function(e, tp, eg, ep, ev, re, r, rp)
							return Duel.IsPlayerAffectedByEffect(tp, m) and e:GetHandler():IsType(TYPE_EQUIP) and
								(not con or con(e, tp, eg, ep, ev, re, r, rp))
						end)
						e2:SetCondition(function(e, tp, eg, ep, ev, re, r, rp)
							return Duel.IsPlayerAffectedByEffect(tp, m) == nil and
								(not con or con(e, tp, eg, ep, ev, re, r, rp))
						end)
						-- cm.global_jc[tc] = cm.global_jc[tc] or {}
						-- cm.global_jc[tc][#cm.global_jc[tc] + 1] = qe
						local eff = effect:Clone()
						eff:SetLabelObject(qe)
						return l(c, eff, ...)
					end
				end
				return 0
			end
			tc:CopyEffect(tc:GetOriginalCode(), 0, 1)
			Card.RegisterEffect = l
		end
	end
end

-- ①效果条件：这张卡或者对方的怪兽召唤•特殊召唤
function cm.thcon(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	return eg:IsExists(function(c, tp)
		return c == e:GetHandler() or c:IsSummonPlayer(1 - tp)
	end, 1, nil, tp)
end

-- 装备魔法卡•同盟怪兽过滤器
function cm.thfilter(c)
	return (c:IsType(TYPE_EQUIP) or c:IsType(TYPE_UNION)) and c:IsAbleToHand()
end

-- ①效果target
function cm.thtg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(cm.thfilter, tp, LOCATION_GRAVE + LOCATION_REMOVED, 0, 1, nil) end
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_GRAVE + LOCATION_REMOVED)
end

-- ①效果operation
function cm.thop(e, tp, eg, ep, ev, re, r, rp)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
	local g = Duel.SelectMatchingCard(tp, cm.thfilter, tp, LOCATION_GRAVE + LOCATION_REMOVED, 0, 1, 1, nil)
	if #g > 0 then
		Duel.SendtoHand(g, nil, REASON_EFFECT)
		Duel.ConfirmCards(1 - tp, g)
	end
end

function cm.actarget(e, te, tp)
	local c = te:GetHandler()
	local e1 = e:GetLabelObject()
	if te:GetLabel() == m then return true end
	for z, v in pairs(cm.global_jc) do
		for i = 1, #v do
			if v[i] == te then
				e:SetLabelObject(z)
				return true
			end
		end
	end
	return false
end

function cm.checkop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetLabelObject()
	-- for z, v in pairs(cm.global_jc) do
	--   for i = 1, #v do
	--	   if v[i] == e then
	--		   c = z
	--	   end
	--   end
	-- end
	tp = c:GetControler()
	cm.checkopn(e, tp, c)
end

function cm.checkopn(e, tp, c, mf)
	--
	if c:IsLocation(LOCATION_HAND) then
		if not c:IsType(TYPE_FIELD) then
			Duel.MoveToField(c, tp, tp, LOCATION_SZONE, POS_FACEUP, true)
		else
			local fc = Duel.GetFieldCard(tp, LOCATION_FZONE, 0)
			if fc then
				Duel.SendtoGrave(fc, REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.MoveToField(c, tp, tp, LOCATION_FZONE, POS_FACEUP, true)
		end
		if not c:IsType(TYPE_CONTINUOUS) and not c:IsType(TYPE_FIELD) and not c:IsType(TYPE_EQUIP) then c:CancelToGrave(false) end
	end
	if c:IsLocation(LOCATION_SZONE) and c:IsType(TYPE_FIELD) then
		local fc = Duel.GetFieldCard(tp, LOCATION_FZONE, 0)
		if fc then
			Duel.SendtoGrave(fc, REASON_RULE)
			Duel.BreakEffect()
		end
		local ta = Duel.GetMatchingGroup(aux.TRUE, tp, 0xfff - LOCATION_MZONE, 0xfff - LOCATION_MZONE, nil)
		local tc = ta:GetFirst()
		Duel.Overlay(tc, c)
		Duel.MoveToField(c, tp, tp, LOCATION_FZONE, POS_FACEUP, true)
	end
	Duel.ChangePosition(c, POS_FACEUP)

	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetOperation(function(e, tp, eg, ep, ev, re, r, rp)
		if not c:IsType(TYPE_CONTINUOUS) and not c:IsType(TYPE_FIELD) and
			(not c:IsType(TYPE_EQUIP) or (c:IsType(TYPE_EQUIP) and not c:GetEquipTarget())) and c:IsLocation(LOCATION_SZONE) and c:IsHasEffect(EFFECT_REMAIN_FIELD) == nil then
			Duel.SendtoGrave(c, REASON_RULE)
		end
		e:Reset()
	end)
	Duel.RegisterEffect(e1, 0)
end
