local s, id = GetID()
local SET_PATROL_BEE = 0xc328

function s.initial_effect(c)
	-- ①：特召 + 装备墓地
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON + CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	-- 生效区域：手卡 + 魔陷区（因为可能变成永续/装备魔法）
	e1:SetRange(LOCATION_HAND + LOCATION_SZONE)
	e1:SetCountLimit(1, id) -- 卡名硬限制
	e1:SetCondition(s.spcon)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)

	-- ②：二速补充素材
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0, TIMINGS_CHECK_MONSTER_E)
	e2:SetCountLimit(1, id + 10000) -- 卡名硬限制
	e2:SetTarget(s.mattg)
	e2:SetOperation(s.matop)
	c:RegisterEffect(e2)

end



-- ===========================
-- 效果②：补充超量素材
-- ===========================

function s.xyzfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_INSECT) and c:IsType(TYPE_XYZ)
end

function s.matfilter(c, sc)
	-- 排除对象自身 (sc)，并且要是能作为素材的卡（排除衍生物等）
	return c ~= sc and c:IsCanOverlay()
end

function s.mattg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and s.xyzfilter(chkc) end
	if chk == 0 then return Duel.IsExistingTarget(s.xyzfilter, tp, LOCATION_MZONE, 0, 1, nil)
		and Duel.IsExistingMatchingCard(s.matfilter, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, 1, e:GetHandler(), nil) end
	
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TARGET)
	Duel.SelectTarget(tp, s.xyzfilter, tp, LOCATION_MZONE, 0, 1, 1, nil)
end

function s.matop(e, tp, eg, ep, ev, re, r, rp)
	local tc = Duel.GetFirstTarget() -- 对象：超量怪兽
	
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_XMATERIAL)
		-- 选那张卡以外的场上1张卡（不取对象）
		local g = Duel.SelectMatchingCard(tp, s.matfilter, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, 1, 1, tc, tc)
		
		if #g > 0 then
			local mat = g:GetFirst()
			-- 变成超量素材
			-- 如果是对方的卡，Duel.Overlay 会处理移动逻辑
			Duel.Overlay(tc, mat)
		end
	end
end

-- ===========================
-- 效果③：自身特召
-- ===========================

-- 发动条件：手卡存在，或者在场上作为永续/装备魔法
function s.spcon(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	return c:IsLocation(LOCATION_HAND) 
		or (c:IsLocation(LOCATION_SZONE) and c:IsFaceup() and (c:IsType(TYPE_CONTINUOUS) or c:IsType(TYPE_EQUIP)))
end

-- Cost过滤器：除自身以外的、昆虫族、可解放
function s.cfilter(c, ft, tp)
	return c:IsRace(RACE_INSECT) 
		and (c:IsFaceup() or c:IsLocation(LOCATION_HAND))
		and c:IsReleasable()
		-- 关键判定：如果怪兽区没空位(ft<=0)，则必须解放场上的怪兽(c:IsLocation(LOCATION_MZONE))
		and (ft > 0 or (c:IsLocation(LOCATION_MZONE) and c:GetSequence() < 5))
end

function s.spcost(e, tp, eg, ep, ev, re, r, rp, chk)
	local c = e:GetHandler()
	local ft = Duel.GetLocationCount(tp, LOCATION_MZONE)
	if chk == 0 then return Duel.IsExistingMatchingCard(s.cfilter, tp, LOCATION_HAND + LOCATION_MZONE, 0, 1, c, ft, tp) end
	
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_RELEASE)
	local g = Duel.SelectMatchingCard(tp, s.cfilter, tp, LOCATION_HAND + LOCATION_MZONE, 0, 1, 1, c, ft, tp)
	Duel.Release(g, REASON_COST)
end

function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return e:GetHandler():IsCanBeSpecialSummoned(e, 0, tp, false, false) end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, e:GetHandler(), 1, 0, 0)
end

-- 墓地装备过滤器：3星昆虫族
function s.eqfilter(c)
	return c:IsRace(RACE_INSECT) and c:IsLevel(3) and not c:IsForbidden()
end

function s.spop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	
	-- 1. 特殊召唤自身
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP) > 0 then
		-- 2. 那之后，处理墓地装备
		-- 检查魔陷区是否有空位，以及墓地是否有目标
		if Duel.GetLocationCount(tp, LOCATION_SZONE) > 0 
			and Duel.IsExistingMatchingCard(s.eqfilter, tp, LOCATION_GRAVE, 0, 1, nil) 
			and Duel.SelectYesNo(tp, aux.Stringid(id, 1)) then
			
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_EQUIP)
			local g = Duel.SelectMatchingCard(tp, s.eqfilter, tp, LOCATION_GRAVE, 0, 1, 1, nil)
			local tc = g:GetFirst()
			
			if tc then
				Duel.Equip(tp, tc, c)
				
				-- 装备限制：必须给装备卡注册限制，否则会立刻破坏
				local e1 = Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_COPY_INHERIT + EFFECT_FLAG_OWNER_RELATE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetReset(RESET_EVENT + RESETS_STANDARD)
				e1:SetValue(s.eqlimit)
				tc:RegisterEffect(e1)
			end
		end
	end
end

-- 装备对象限制：只能装备给这张卡
function s.eqlimit(e, c)
	return e:GetOwner() == c
end