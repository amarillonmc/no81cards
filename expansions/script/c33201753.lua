--界域编织者 路径邮差
local s, id = GetID()
local SET_REALM_WEAVER = 0xa328

function s.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--link
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetRange(LOCATION_PZONE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EFFECT_LINK_SPELL_KOISHI)
	e0:SetValue(LINK_MARKER_TOP)
	c:RegisterEffect(e0)	
-- ①：二速回手 + 额外特召
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_TOHAND + CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)   -- 诱发即时效果
	e1:SetCode(EVENT_FREE_CHAIN)		 -- 自由时点
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0, TIMINGS_CHECK_MONSTER + TIMING_MAIN_END) -- 提示时点优化
	e1:SetCountLimit(1, id)		   
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	-- ①：连接端有怪兽特召时检索
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 0))
	e2:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O) -- 诱发效果
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)			 -- 特殊召唤成功时
	e2:SetProperty(EFFECT_FLAG_DELAY)				 -- 即使在连锁2以后特召也能发动
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1, id+10000)					 -- 卡名1回合1次
	e2:SetCondition(s.srcon)
	e2:SetTarget(s.srtg)
	e2:SetOperation(s.srop)
	c:RegisterEffect(e2)
end
-- 过滤额外卡组表侧的“界域编织者”
function s.spfilter(c, e, tp)
	return c:IsSetCard(SET_REALM_WEAVER) 
		and c:IsFaceup() -- 【重点】使用 IsFaceup
		and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end

function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
	local c = e:GetHandler()
	-- 发动条件：自身能回手即可
	-- 虽然特召是后续可选，但通常如果完全无法特召（如没有格子且没怪回手腾格子），也允许发动单纯为了回手
	if chk == 0 then return c:IsAbleToHand() end
	
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, c, 1, 0, 0)
end

function s.spop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	
	-- 1. 处理回手
	-- 必须确保卡片还在场上且与效果相关，并且成功回到了手卡
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c, nil, REASON_EFFECT) > 0 and c:IsLocation(LOCATION_HAND) then
		
		-- 2. 处理“那之后”的特召
		-- 回手后，场上格子状况发生了变化，需要重新检测
		-- 灵摆怪兽从额外卡组特召（规则上）必须出在“额外怪兽区”或者“连接怪兽所连接区”
		-- 因此 Duel.GetLocationCountFromEx 是必须的
		if Duel.GetLocationCountFromEx(tp) <= 0 then return end
		
		local g = Duel.GetMatchingGroup(s.spfilter, tp, LOCATION_EXTRA, 0, nil, e, tp)
		
		-- 询问是否特召
		if #g > 0 and Duel.SelectYesNo(tp, aux.Stringid(id, 1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
			local sg = g:Select(tp, 1, 1, nil)
			Duel.SpecialSummon(sg, 0, tp, tp, false, false, POS_FACEUP)
		end
	end
end

function s.eftg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c) and c:IsSetCard(SET_REALM_WEAVER)
end

-- 判断特召的怪兽是否出现在这张卡的连接区
function s.cfilter(c, lc)
	-- 获取该连接怪兽当前指向的所有格子中的怪兽
	return lc:GetLinkedGroup():IsContains(c) and c:GetSequence()<5
end

function s.srcon(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	-- 必须在场上表侧表示存在，且特召的怪兽组(eg)中存在于连接端的怪兽
	return c:IsFaceup() and eg:IsExists(s.cfilter, 1, nil, c)
-- 过滤条件：是“应答解析”或者“界域编织者”字段，且是魔法/陷阱卡，且能盖放
end
function s.setfilter(c)
	return c:IsSetCard(SET_REALM_WEAVER)
		and c:IsType(TYPE_SPELL + TYPE_TRAP)
		and c:IsSSetable()
end

function s.srtg(e, tp, eg, ep, ev, re, r, rp, chk)
	-- 检查后场是否有空位 (Location Count > 0) 且卡组有符合条件的卡
	if chk == 0 then return Duel.GetLocationCount(tp, LOCATION_SZONE) > 0
		and Duel.IsExistingMatchingCard(s.setfilter, tp, LOCATION_DECK+LOCATION_GRAVE, 0, 1, nil) end
end

function s.srop(e, tp, eg, ep, ev, re, r, rp)
	-- 处理时再次检查格子数量
	if Duel.GetLocationCount(tp, LOCATION_SZONE) <= 0 then return end
	
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SET)
	-- 从卡组选择1张
	local g = Duel.SelectMatchingCard(tp, s.setfilter, tp, LOCATION_DECK+LOCATION_GRAVE, 0, 1, 1, nil)
	
	if #g > 0 then
		-- 直接盖放
		Duel.SSet(tp, g:GetFirst())
		
		-- 如果是速攻魔法或陷阱卡，通常可以提示一下（SSet会自动处理，但有些脚本习惯加Confirm）
		-- 这里标准写法直接SSet即可，不需要ConfirmCards，因为SSet本身会展示给对手看（虽然是盖放，但来源是公开区域或已知检索，Ygopro底层处理了日志）
	end
end