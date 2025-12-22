--界域编织者 框架管理员
local s, id = GetID()
local SET_REALM_WEAVER = 0xa328

function s.initial_effect(c)
	-- 连接召唤规则
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,s.matfilter,2,2)
	
	-- ①：移动 + P设置 + 条件破坏
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_TOHAND + CATEGORY_DESTROY) -- 主要是破坏，放置P区不属于Category
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1, id) -- 卡名硬限制
	e1:SetTarget(s.mvtg)
	e1:SetOperation(s.mvop)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(1000)
	e2:SetCondition(s.atkcon)
	c:RegisterEffect(e2)
end

-- 素材条件：电子界族 5星
function s.matfilter(c, lc, sumtype, tp)
	return c:IsRace(RACE_CYBERSE) and c:IsLevel(5)
end

-- 过滤卡组中的“界域编织者”灵摆怪兽
function s.pcfilter(c)
	return c:IsSetCard(SET_REALM_WEAVER) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end

-- 检查是否有可移动的空位 (Main Monster Zone 0-4)
function s.check_move_zone(c, tp)
	local seq = c:GetSequence()
	for i = 0, 4 do
		-- 必须是不同的格子，且该格子可用
		if i ~= seq and Duel.CheckLocation(tp, LOCATION_MZONE, i) then
			return true
		end
	end
	return false
end

function s.mvtg(e, tp, eg, ep, ev, re, r, rp, chk)
	local c = e:GetHandler()
	if chk == 0 then
		return s.check_move_zone(c, tp) -- 1. 能移动
			and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) -- 2. 有灵摆格子
			and Duel.IsExistingMatchingCard(s.pcfilter, tp, LOCATION_DECK, 0, 1, nil) -- 3. 卡组有货
	end
	-- 破坏是后续可选，且不取对象，所以Category里写DESTROY
	Duel.SetOperationInfo(0, CATEGORY_DESTROY, nil, 0, 1-tp, 1)
end

function s.mvop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	
	-- --- 步骤1：移动 ---
	if not c:IsRelateToEffect(e) or c:IsControler(1-tp) or not s.check_move_zone(c, tp) then return end
	
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOZONE)
	-- 让玩家选择一个可用的主要怪兽区域
	local flag = 0
	local seq = c:GetSequence()
	for i = 0, 4 do
		if i ~= seq and Duel.CheckLocation(tp, LOCATION_MZONE, i) then
			flag = flag + (1 << i)
		end
	end
	-- 弹出格子选择界面
	local s_seq = Duel.SelectDisableField(tp, 1, LOCATION_MZONE, 0, ~flag)
	local n_seq = math.log(s_seq, 2)
	
	-- 执行移动
	Duel.MoveSequence(c, n_seq)
	
	-- --- 步骤2：放置灵摆 ---
	-- 移动后，再次检查灵摆区域状况（防止移动过程中触发了什么东西把P区填满了，虽然很少见）
	if Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOFIELD)
		local g = Duel.SelectMatchingCard(tp, s.pcfilter, tp, LOCATION_DECK, 0, 1, 1, nil)
		if #g > 0 then
			Duel.MoveToField(g:GetFirst(), tp, tp, LOCATION_PZONE, POS_FACEUP, true)
			
			-- --- 步骤3：条件破坏 ---
			-- 检查由于“那之后”的性质，移动和放置P卡后，是否处于连接状态
			-- 注意：IsLinkState 是动态判断的，位置变了，状态可能就变了
			local dg = Duel.GetMatchingGroup(nil, tp, 0, LOCATION_ONFIELD, nil)
			if c:IsLinkState() and #dg > 0 and Duel.SelectYesNo(tp, aux.Stringid(id, 1)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DESTROY)
				local sg = dg:Select(tp, 1, 1, nil)
				Duel.HintSelection(sg)
				Duel.Destroy(sg, REASON_EFFECT)
			end
		end
	end
end

function s.atkcon(e)
	return e:GetHandler():IsLinkState()
end