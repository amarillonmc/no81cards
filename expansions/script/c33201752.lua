--界域编织者 内存总线
local s, id = GetID()
function s.initial_effect(c)
	-- 灵摆刻度设置
	aux.EnablePendulumAttribute(c)
	--link
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetRange(LOCATION_PZONE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EFFECT_LINK_SPELL_KOISHI)
	e0:SetValue(LINK_MARKER_TOP_RIGHT)
	c:RegisterEffect(e0)	
	
	-- ===================
	-- 灵摆效果
	-- ===================
	
	-- ①：抗性与攻击力提升
	-- 不会被取对象
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(LOCATION_MZONE, 0) -- 仅限自己场上
	e1:SetTarget(s.indtg)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	
	-- 攻击力上升
	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_MZONE, 0)
	e2:SetTarget(s.indtg) -- 使用同样的对象过滤条件
	e2:SetValue(s.atkval)
	c:RegisterEffect(e2)

	-- ===================
	-- 怪兽效果
	-- ===================
	
	-- ①：手卡特召 + 额外特召
	local e3 = Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id, 0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1, id)
	e3:SetTarget(s.sptg1)
	e3:SetOperation(s.spop1)
	c:RegisterEffect(e3)
	
	-- ②：灵摆区特召 + 自身放置
	local e4 = Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id, 1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1, id + 10000)
	e4:SetTarget(s.sptg2)
	e4:SetOperation(s.spop2)
	c:RegisterEffect(e4)
end

-- ===================
-- 灵摆效果处理函数
-- ===================

-- 判断是否为“连接状态”的怪兽
function s.indtg(e, c)
	return c:IsLinkState()
end

-- 计算攻击力提升数值
function s.atkval(e, c)
	-- 统计全场（双方）连接状态的怪兽数量
	return Duel.GetMatchingGroupCount(Card.IsLinkState, 0, LOCATION_MZONE, LOCATION_MZONE, nil) * 300
end

-- ===================
-- 怪兽效果①：手卡特召
-- ===================

function s.sptg1(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
		and e:GetHandler():IsCanBeSpecialSummoned(e, 0, tp, false, false) end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, c, 1, 0, 0)
end

function s.exfilter(c, e, tp)
	return c:IsFaceup() 
		and c:IsSetCard(0xa328) 
		and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
		and Duel.GetLocationCountFromEx(tp, tp, nil, c) > 0 -- 检查额外特召位
end

function s.spop1(e, tp, eg, ep, ev, re, r, rp)
	if Duel.GetLocationCount(tp, LOCATION_MZONE) <= 0 then return end
	-- 1. 特殊召唤自身
	if Duel.SpecialSummon(e:GetHandler(), 0, tp, tp, false, false, POS_FACEUP) > 0 then
		-- 2. 处理后续效果：选1只额外卡组表侧怪兽特召
		local g = Duel.GetMatchingGroup(s.exfilter, tp, LOCATION_EXTRA, 0, nil, e, tp)
		if #g > 0 and Duel.SelectYesNo(tp, aux.Stringid(id, 2)) then -- 询问是否发动后续
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
			local sg = g:Select(tp, 1, 1, nil)
			Duel.SpecialSummon(sg, 0, tp, tp, false, false, POS_FACEUP)
		end
	end
end

-- ===================
-- 怪兽效果②：灵摆互换
-- ===================

function s.pfilter(c, e, tp)
	return c:IsSetCard(0xa328) 
		and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end

function s.sptg2(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chkc then return chkc:IsLocation(LOCATION_PZONE) and chkc:IsControler(tp) and s.pfilter(chkc, e, tp) end
	if chk == 0 then return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
		and Duel.IsExistingTarget(s.pfilter, tp, LOCATION_PZONE, 0, 1, nil, e, tp)
	end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
	local g = Duel.SelectTarget(tp, s.pfilter, tp, LOCATION_PZONE, 0, 1, 1, nil, e, tp)
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, g, 1, 0, 0)
end

function s.spop2(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local tc = Duel.GetFirstTarget()
	
	if tc:IsRelateToEffect(e) then
		-- 特殊召唤灵摆区的卡
		if Duel.SpecialSummon(tc, 0, tp, tp, false, false, POS_FACEUP) > 0 then
			-- 只有特召成功，且自身还在场上，才能放置到灵摆区
			if c:IsRelateToEffect(e) and c:IsFaceup() and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))  then
				Duel.BreakEffect()
				-- 放置到灵摆区域的核心函数
				Duel.MoveToField(c, tp, tp, LOCATION_PZONE, POS_FACEUP, true)
			end
		end
	end
end