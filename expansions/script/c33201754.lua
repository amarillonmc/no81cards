--界域编织者 防火墙卫士
local s, id = GetID()
local SET_REALM_WEAVER = 0xa328

function s.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--link
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetRange(LOCATION_PZONE)
	e10:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e10:SetCode(EFFECT_LINK_SPELL_KOISHI)
	e10:SetValue(LINK_MARKER_TOP_LEFT)
	c:RegisterEffect(e10)   
	--immune
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_IMMUNE_EFFECT)
	e0:SetRange(LOCATION_PZONE)
	e0:SetTargetRange(LOCATION_MZONE,0)
	e0:SetTarget(s.immtg)
	e0:SetValue(s.immval)
	c:RegisterEffect(e0)
	-- ①：弹回手卡
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)	   -- 启动效果（主要阶段发动）
	e1:SetRange(LOCATION_MZONE)		 -- 在怪兽区域发动
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)-- 取对象效果
	e1:SetCountLimit(1)				 -- 【注意】这是软限制，每张卡每回合都能用一次
	e1:SetCondition(s.thcon)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)

	-- ②：灵摆区特召 + 自身放置
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O) -- 诱发即时效果（对方回合也能发动）
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0, TIMINGS_CHECK_MONSTER + TIMING_END_PHASE) -- 设置提示时点，方便在对方回合发动
	e2:SetCountLimit(1, id) -- 【建议保留】卡名硬限制
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end

function s.immtg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c)
end
function s.immval(e,re)
	return re:IsActivated() and re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

-- 发动条件：这张卡必须是“连接状态”
function s.thcon(e, tp, eg, ep, ev, re, r, rp)
	return e:GetHandler():IsLinkState()
end

function s.thtg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	-- chkc检查：必须是对方场上的卡，且能回手卡
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and chkc:IsAbleToHand() end
	-- chk==0检查：是否存在合法的对象
	if chk == 0 then return Duel.IsExistingTarget(Card.IsAbleToHand, tp, 0, LOCATION_ONFIELD, 1, nil) end
	
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_RTOHAND)
	-- 选择对方场上1张卡
	local g = Duel.SelectTarget(tp, Card.IsAbleToHand, tp, 0, LOCATION_ONFIELD, 1, 1, nil)
	
	-- 设置操作信息（为了UI提示和AI判断）
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, g, 1, 0, 0)
end

function s.thop(e, tp, eg, ep, ev, re, r, rp)
	local tc = Duel.GetFirstTarget()
	-- 效果处理时，再次检查对象是否有效
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc, nil, REASON_EFFECT)
	end
end

-- ===================
-- 怪兽效果②：
-- ===================

-- 过滤灵摆区的“界域编织者”卡
function s.pfilter(c, e, tp)
	return c:IsSetCard(SET_REALM_WEAVER) 
		and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end

function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	local c = e:GetHandler()
	-- 取对象检查：P区有符合条件的卡
	if chkc then return chkc:IsLocation(LOCATION_PZONE) and chkc:IsControler(tp) and s.pfilter(chkc, e, tp) end
	
	-- 发动条件检查：
	-- 1. 自身能特召
	-- 2. 场上有至少2个空位（给自己和P区那张卡）
	-- 3. 存在合法的取对象目标
	if chk == 0 then 
		return not Duel.IsPlayerAffectedByEffect(tp,59822133) -- 防范《青眼精灵龙》限制同时特召2只
			and Duel.GetLocationCount(tp, LOCATION_MZONE) >= 2
			and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
			and Duel.IsExistingTarget(s.pfilter, tp, LOCATION_PZONE, 0, 1, nil, e, tp)
	end
	
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
	local g = Duel.SelectTarget(tp, s.pfilter, tp, LOCATION_PZONE, 0, 1, 1, nil, e, tp)
	
	-- 设置操作信息：特召2只（手卡的自己 + 选中的P卡）
	g:AddCard(c)
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, g, 2, 0, 0)
end

function s.spop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local tc = Duel.GetFirstTarget()
	
	-- 处理时必须满足：
	-- 1. 自身还在手卡
	-- 2. 对象还在灵摆区
	-- 3. 两个格子都还在
	-- 4. 没有受到无法同时特召2只的限制
	if not c:IsRelateToEffect(e) then return end
	if not tc:IsRelateToEffect(e) then return end
	
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp, LOCATION_MZONE) < 2 then return end
	
	-- 必须两张都能特召才执行（文案逻辑通常为“这张卡和那张卡特殊召唤”，暗示同时性）
	if c:IsCanBeSpecialSummoned(e, 0, tp, false, false) 
		and tc:IsCanBeSpecialSummoned(e, 0, tp, false, false) then
		
		-- 使用 Step 方式同时特召
		Duel.SpecialSummonStep(c, 0, tp, tp, false, false, POS_FACEUP)
		Duel.SpecialSummonStep(tc, 0, tp, tp, false, false, POS_FACEUP)
		
		Duel.SpecialSummonComplete()
	end
end