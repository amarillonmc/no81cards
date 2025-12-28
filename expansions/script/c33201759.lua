--界域编织者 超速算法
local s, id = GetID()
local SET_REALM_WEAVER = 0xa328

function s.initial_effect(c)
	-- 永续魔法发动
	local e0 = Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)

	-- ①：连接端特召触发三选一
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON + CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY) -- 确保特召结算完后触发
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1, id) -- 卡名1回合1次
	e1:SetCondition(s.effcon)
	e1:SetTarget(s.efftg)
	e1:SetOperation(s.effop)
	c:RegisterEffect(e1)
end

-- 判定特召的怪兽是否在连接区
function s.cfilter(c)
	local tp=c:GetControler()
	local lg1=Duel.GetLinkedGroup(tp,1,1)
	local lg2=Duel.GetLinkedGroup(1-tp,1,1)
	lg1:Merge(lg2)
	return c:IsFaceup() and lg1 and lg1:IsContains(c)
end

function s.effcon(e, tp, eg, ep, ev, re, r, rp)
	-- eg 包含本次连锁特召的所有怪兽
	return eg:IsExists(s.cfilter, 1, nil)
end

-- 各选项的过滤器
function s.spfilter(c, e, tp)
	return c:IsSetCard(SET_REALM_WEAVER) 
		and c:IsType(TYPE_PENDULUM) 
		and c:IsFaceup() 
		and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end

function s.thfilter(c)
	return c:IsAbleToHand()
end

function s.atkfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_CYBERSE)
end

function s.efftg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		-- 检查至少有一个选项是合法的
		local res1 = Duel.GetLocationCountFromEx(tp) > 0 
			and Duel.IsExistingMatchingCard(s.spfilter, tp, LOCATION_EXTRA, 0, 1, nil, e, tp)
		local res2 = Duel.IsExistingMatchingCard(s.thfilter, tp, 0, LOCATION_ONFIELD, 1, nil)
		local res3 = Duel.IsExistingMatchingCard(s.atkfilter, tp, LOCATION_MZONE, 0, 1, nil)
		return res1 or res2 or res3
	end

	-- 动态构建可发动的选项
	local ops = {}
	local opval = {}
	local off = 1
	
	-- 选项1：特召
	if Duel.GetLocationCountFromEx(tp) > 0 
		and Duel.IsExistingMatchingCard(s.spfilter, tp, LOCATION_EXTRA, 0, 1, nil, e, tp) then
		ops[off] = aux.Stringid(id, 1)
		opval[off] = 0
		off = off + 1
	end
	-- 选项2：回手
	if Duel.IsExistingMatchingCard(s.thfilter, tp, 0, LOCATION_ONFIELD, 1, nil) then
		ops[off] = aux.Stringid(id, 2)
		opval[off] = 1
		off = off + 1
	end
	-- 选项3：2次攻击
	if Duel.IsExistingMatchingCard(s.atkfilter, tp, LOCATION_MZONE, 0, 1, nil) then
		ops[off] = aux.Stringid(id, 3)
		opval[off] = 2
		off = off + 1
	end

	local op = Duel.SelectOption(tp, table.unpack(ops))
	local sel = opval[op + 1]
	e:SetLabel(sel)

	-- 设置对应的 Category
	if sel == 0 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_EXTRA)
	elseif sel == 1 then
		e:SetCategory(CATEGORY_TOHAND)
		Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, 1-tp, LOCATION_ONFIELD)
	else
		e:SetCategory(0)
	end
end

function s.effop(e, tp, eg, ep, ev, re, r, rp)
	local sel = e:GetLabel()

	-- ● 从额外卡组（表侧）特召
	if sel == 0 then
		if Duel.GetLocationCountFromEx(tp) <= 0 then return end
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
		local g = Duel.SelectMatchingCard(tp, s.spfilter, tp, LOCATION_EXTRA, 0, 1, 1, nil, e, tp)
		if #g > 0 then
			Duel.SpecialSummon(g, 0, tp, tp, false, false, POS_FACEUP)
		end

	-- ● 对方场上1张卡回到手卡
	elseif sel == 1 then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_RTOHAND)
		local g = Duel.SelectMatchingCard(tp, s.thfilter, tp, 0, LOCATION_ONFIELD, 1, 1, nil)
		if #g > 0 then
			Duel.HintSelection(g)
			Duel.SendtoHand(g, nil, REASON_EFFECT)
		end

	-- ● 电子界族怪兽2次攻击
	elseif sel == 2 then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_FACEUP)
		local g = Duel.SelectMatchingCard(tp, s.atkfilter, tp, LOCATION_MZONE, 0, 1, 1, nil)
		if #g > 0 then
			local tc = g:GetFirst()
			Duel.HintSelection(g)
			-- 增加2次攻击效果
			local e1 = Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_EXTRA_ATTACK)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_END)
			tc:RegisterEffect(e1)
		end
	end
end