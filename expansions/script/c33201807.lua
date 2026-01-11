--巡猎蜂攻击指令
local s, id = GetID()

function s.initial_effect(c)
	-- ①：发动（翻面时）
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0, TIMINGS_CHECK_MONSTER + TIMING_END_PHASE)
	e1:SetCountLimit(1, id) -- ①效果硬限制
	e1:SetTarget(s.distg)
	e1:SetOperation(s.disop)
	c:RegisterEffect(e1)
	
	-- ①：已经表侧存在时的发动效果
	local e2 = e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(s.discon) -- 必须是已经表侧表示存在的情况
	c:RegisterEffect(e2)

	-- ②：墓地垫素材
	local e3 = Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id, 1))
	e3:SetType(EFFECT_TYPE_QUICK_O) -- 陷阱在墓地通常是二速
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1, id + 10000) -- ②效果硬限制
	e3:SetTarget(s.mattg)
	e3:SetOperation(s.matop)
	c:RegisterEffect(e3)
end

-- ===========================
-- 效果①：去除素材并无效
-- ===========================

function s.discon(e, tp, eg, ep, ev, re, r, rp)
	-- 如果是 EFFECT_TYPE_QUICK_O，说明卡片已经在场，不需要额外检查，
	-- 但为了严谨，确保卡片是表侧
	return e:GetHandler():IsFaceup()
end

-- 过滤有素材的昆虫族超量怪兽
function s.rmfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_INSECT) and c:IsType(TYPE_XYZ) 
		and c:CheckRemoveOverlayCard(tp, 1, REASON_EFFECT)
end

-- 过滤需要被无效的卡
function s.disfilter(c)
	return c:IsFaceup() and not c:IsDisabled()
end

function s.distg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and s.disfilter(chkc) end
	if chk == 0 then return Duel.IsExistingTarget(s.disfilter, tp, 0, LOCATION_ONFIELD, 1, nil)
		and Duel.IsExistingMatchingCard(s.rmfilter, tp, LOCATION_MZONE, 0, 1, nil) end
	
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_NEGATE)
	local g = Duel.SelectTarget(tp, s.disfilter, tp, 0, LOCATION_ONFIELD, 1, 1, nil)
	Duel.SetOperationInfo(0, CATEGORY_DISABLE, g, 1, 0, 0)
end

function s.disop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	-- 永续陷阱的效果处理时，必须自身还在场上才有效
	if not c:IsRelateToEffect(e) then return end
	
	local tc = Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end

	-- 步骤1：选自己场上1个昆虫族超量怪兽去除素材
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DEATTACHFROM)
	local g = Duel.SelectMatchingCard(tp, s.rmfilter, tp, LOCATION_MZONE, 0, 1, 1, nil)
	
	if #g > 0 then
		local xc = g:GetFirst()
		-- 去除素材 (注意：这是效果处理，不是Cost)
		if xc:RemoveOverlayCard(tp, 1, 1, REASON_EFFECT) ~= 0 then
			-- 步骤2：无效对象
			if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsDisabled() then
				Duel.NegateRelatedChain(tc, RESET_TURN_SET)
				
				local e1 = Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT + RESETS_STANDARD)
				tc:RegisterEffect(e1)
				
				local e2 = Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetValue(RESET_TURN_SET)
				e2:SetReset(RESET_EVENT + RESETS_STANDARD)
				tc:RegisterEffect(e2)
				
				if tc:IsType(TYPE_TRAPMONSTER) then
					local e3 = Effect.CreateEffect(c)
					e3:SetType(EFFECT_TYPE_SINGLE)
					e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
					e3:SetReset(RESET_EVENT + RESETS_STANDARD)
					tc:RegisterEffect(e3)
				end
			end
		end
	end
end

-- ===========================
-- 效果②：墓地垫素材
-- ===========================

function s.xyzfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_INSECT) and c:IsType(TYPE_XYZ)
end

function s.mattg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.xyzfilter(chkc) end
	if chk == 0 then return Duel.IsExistingTarget(s.xyzfilter, tp, LOCATION_MZONE, 0, 1, nil) end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TARGET)
	Duel.SelectTarget(tp, s.xyzfilter, tp, LOCATION_MZONE, 0, 1, 1, nil)
end

function s.matop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local tc = Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Overlay(tc, c)
	end
end