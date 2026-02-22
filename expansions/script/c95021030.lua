-- 源能特工 壹决
local s, id = GetID()

function s.initial_effect(c)
	-- 效果①：自己主要阶段2从手卡特殊召唤（规则效果）
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon1)
	c:RegisterEffect(e1)

	-- 效果②：攻击破坏对方怪兽时，这个回合不会被破坏
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1, id)
	e2:SetCondition(s.condition2)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
	c:RegisterEffect(e2)

	-- 效果③：主要阶段1发动，除外全场其他怪兽，跳阶段并赋予效果，结束时返回
	local e3 = Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id, 1))
	e3:SetCategory(CATEGORY_REMOVE + CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1, id + 1 + EFFECT_COUNT_CODE_DUEL)  -- 决斗中一次
	e3:SetCondition(s.condition3)
	e3:SetTarget(s.target3)
	e3:SetOperation(s.operation3)
	c:RegisterEffect(e3)
end

-- 效果①条件：主要阶段2且场上有空位
function s.spcon1(e, c)
	if c == nil then return true end
	local tp = c:GetControler()
	return Duel.GetCurrentPhase() == PHASE_MAIN2 and Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
end

-- 效果②条件：攻击破坏对方怪兽
function s.condition2(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local bc = c:GetBattleTarget()
	return bc and bc:IsControler(1 - tp) and bc:IsReason(REASON_BATTLE)
end
function s.target2(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return true end
end
function s.operation2(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		-- 这个回合不会被破坏
		local e1 = Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_END)
		c:RegisterEffect(e1)
	end
end

-- 效果③条件：主要阶段1
function s.condition3(e, tp, eg, ep, ev, re, r, rp)
	if Duel.GetTurnCount(tp) == 1 then return false end
	return Duel.GetCurrentPhase() == PHASE_MAIN1
end
-- 效果③目标：对方场上1只怪兽
function s.target3(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chkc then return chkc:IsControler(1 - tp) and chkc:IsLocation(LOCATION_MZONE) end
	if chk == 0 then
		return Duel.IsExistingTarget(aux.TRUE, tp, 0, LOCATION_MZONE, 1, nil)
	end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TARGET)
	local g = Duel.SelectTarget(tp, aux.TRUE, tp, 0, LOCATION_MZONE, 1, 1, nil)
	Duel.SetOperationInfo(0, CATEGORY_REMOVE, nil, 0, PLAYER_ALL, LOCATION_MZONE)
end

-- 效果③操作（参考PSY骨架王Ω的标记返回机制）
function s.operation3(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local tc = Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or not c:IsFaceup() or not tc or not tc:IsRelateToEffect(e) then return end
	-- 获取除自身和对象外的所有怪兽
	local g = Duel.GetMatchingGroup(aux.TRUE, tp, LOCATION_MZONE, LOCATION_MZONE, tc)
	g:RemoveCard(c)
	if #g == 0 then return end
	-- 临时除外它们
	if Duel.Remove(g, POS_FACEUP, REASON_EFFECT + REASON_TEMPORARY) ~= 0 then
		local removed = Duel.GetOperatedGroup()
		-- 跳转到战斗阶段开始
		if Duel.GetCurrentPhase() ~= PHASE_BATTLE_START then
			local ph = Duel.GetCurrentPhase()
			Duel.SkipPhase(Duel.GetTurnPlayer(), ph, RESET_PHASE + ph, 1)
		end
		-- 自身攻击力上升500
		local e1 = Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_PHASE + PHASE_BATTLE)
		c:RegisterEffect(e1)
		-- 所有怪兽必须攻击
		local e2 = Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_MUST_ATTACK)
		e2:SetTargetRange(LOCATION_MZONE, 0)
		e2:SetReset(RESET_PHASE + PHASE_BATTLE)
		Duel.RegisterEffect(e2, tp)
		local e3 = e2:Clone()
		e3:SetTargetRange(0, LOCATION_MZONE)
		Duel.RegisterEffect(e3, tp)
		-- 禁止发动效果
		local e4 = Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD)
		e4:SetCode(EFFECT_CANNOT_ACTIVATE)
		e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e4:SetTargetRange(1, 1)
		e4:SetValue(1)
		e4:SetReset(RESET_PHASE + PHASE_BATTLE)
		Duel.RegisterEffect(e4, tp)

		-- 为每个被除外的怪兽打上标记（使用唯一的FieldID）
		local fid = c:GetFieldID()
		local rc = removed:GetFirst()
		while rc do
			rc:RegisterFlagEffect(id, RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_BATTLE, 0, 1, fid)
			rc = removed:GetNext()
		end

		-- 注册战斗阶段结束时的返回效果
		local e5 = Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
		e5:SetCode(EVENT_PHASE + PHASE_BATTLE)
		e5:SetCountLimit(1)
		e5:SetLabel(fid)
		e5:SetOperation(s.returnop)
		e5:SetReset(RESET_PHASE + PHASE_BATTLE)
		Duel.RegisterEffect(e5, tp)
	end
end

-- 战斗阶段结束时，特殊召唤被标记的除外怪兽
function s.returnop(e, tp, eg, ep, ev, re, r, rp)
	local fid = e:GetLabel()
	-- 获取所有在除外区的卡
	local g = Duel.GetMatchingGroup(aux.TRUE, tp, LOCATION_REMOVED, LOCATION_REMOVED, nil)
	-- 筛选出带有对应标记的卡
	local spg = g:Filter(function(c) return c:GetFlagEffectLabel(id) == fid end, nil)
	if #spg == 0 then return end
	-- 按原持有者分组
	local p1g = spg:Filter(function(c) return c:GetOwner() == tp end, nil)
	local p2g = spg:Filter(function(c) return c:GetOwner() == 1 - tp end, nil)

	-- 特殊召唤到原持有者场上
	if #p1g > 0 then
		local ft1 = Duel.GetLocationCount(tp, LOCATION_MZONE)
		if ft1 > 0 then
			if #p1g > ft1 then
				Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
				local sg = p1g:Select(tp, ft1, ft1, nil)
				Duel.SpecialSummon(sg, 0, tp, tp, false, false, POS_FACEUP)
			else
				Duel.SpecialSummon(p1g, 0, tp, tp, false, false, POS_FACEUP)
			end
		end
	end
	if #p2g > 0 then
		local ft2 = Duel.GetLocationCount(1 - tp, LOCATION_MZONE)
		if ft2 > 0 then
			if #p2g > ft2 then
				Duel.Hint(HINT_SELECTMSG, 1 - tp, HINTMSG_SPSUMMON)
				local sg = p2g:Select(1 - tp, ft2, ft2, nil)
				Duel.SpecialSummon(sg, 0, tp, 1 - tp, false, false, POS_FACEUP)
			else
				Duel.SpecialSummon(p2g, 0, tp, 1 - tp, false, false, POS_FACEUP)
			end
		end
	end
end