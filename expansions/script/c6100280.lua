--暴雨的刻时
local s,id,o=GetID()
function s.initial_effect(c)
	--①：根据「朦雨」同调·连接怪兽数量适用效果
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.efftg)
	e1:SetOperation(s.effop)
	c:RegisterEffect(e1)

	--②：墓地效果（回卡组与特召）
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,id+1)
	e2:SetTarget(s.eff2tg)
	e2:SetOperation(s.eff2op)
	c:RegisterEffect(e2)
end

-- === 效果①：条件与目标 ===
function s.ctfilter(c)
	return c:IsSetCard(0x613) and c:IsType(TYPE_SYNCHRO+TYPE_LINK) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end

-- 【完美重构】获取相邻可用怪兽区的 Flag 掩码
function s.get_adj_zones(c)
	local p = c:GetControler()
	local seq = c:GetSequence()
	local flag = 0
	-- 主要怪兽区的左右移动
	if seq > 0 and seq < 5 and Duel.CheckLocation(p, LOCATION_MZONE, seq - 1) then flag = flag | (1 << (seq - 1)) end
	if seq < 4 and Duel.CheckLocation(p, LOCATION_MZONE, seq + 1) then flag = flag | (1 << (seq + 1)) end
	-- 额外怪兽区向下移动
	if seq == 5 and Duel.CheckLocation(p, LOCATION_MZONE, 1) then flag = flag | (1 << 1) end
	if seq == 6 and Duel.CheckLocation(p, LOCATION_MZONE, 3) then flag = flag | (1 << 3) end
	
	return flag
end

function s.movfilter(c)
	return s.get_adj_zones(c) ~= 0
end

function s.tdfilter_eff1(c)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsAbleToDeck()
end

function s.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(s.ctfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	if chk==0 then
		if ct == 0 then return false end
		local b1 = Duel.IsExistingMatchingCard(s.movfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		local b2 = Duel.IsExistingMatchingCard(s.tdfilter_eff1,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil)
		if ct >= 1 and not b1 then return false end
		if ct >= 3 and not b2 then return false end
		return true
	end
	if ct >= 3 then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,LOCATION_ONFIELD+LOCATION_GRAVE)
	end
end

-- === 效果①：处理分歧 ===
function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetMatchingGroupCount(s.ctfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	
	-- ● 1只以上：移动相邻怪兽
	if ct >= 1 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2)) -- "选择要移动的怪兽"
		local g1=Duel.SelectMatchingCard(tp,s.movfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		if #g1>0 then
			Duel.HintSelection(g1)
			local tc = g1:GetFirst()
			local p = tc:GetControler()
			local flag = s.get_adj_zones(tc)
			
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
			if p == tp then
				-- 自己场上的移动：按位取反屏蔽不可用区域，提取 0~4 序列
				local s_zone = Duel.SelectDisableField(tp, 1, LOCATION_MZONE, 0, ~flag)
				local n_seq = math.log(s_zone, 2)
				Duel.MoveSequence(tc, n_seq)
			else
				-- 对方场上的移动：对方场地占据 16~23 位，需要左移掩码，并在解算时右移回去
				local s_zone = Duel.SelectDisableField(tp, 1, 0, LOCATION_MZONE, ~(flag << 16))
				local n_seq = math.log(s_zone >> 16, 2)
				Duel.MoveSequence(tc, n_seq)
			end
		end
	end
	
	-- ● 3只以上：弹场上/墓地
	if ct >= 3 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g2=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.tdfilter_eff1),tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
		if #g2>0 then
			Duel.HintSelection(g2)
			Duel.SendtoDeck(g2,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		end
	end
	
	-- ● 5只以上：除外区效果无效化
	if ct >= 5 then
		Duel.BreakEffect()
		local chn = Duel.GetCurrentChain()
		for i=1, chn do
			local loc = Duel.GetChainInfo(i, CHAININFO_TRIGGERING_LOCATION)
			-- 如果触发该效果的位置属于除外区，将此连锁结点的效果无效
			if (loc & LOCATION_REMOVED) ~= 0 then
				Duel.NegateEffect(i)
			end
		end
	end
end

function s.negop(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if (loc & LOCATION_REMOVED) ~= 0 and Duel.IsChainDisablable(ev) then
		Duel.NegateEffect(ev)
	end
end

-- === 效果②：纯净版多目标组合验证与选取 ===
function s.sp_filter(c,e,tp,zone)
	return c:IsSetCard(0x613) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function s.td_filter(c)
	return c:IsSetCard(0x613) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end

-- 检查第1张卡（它必须有能和它互补的第2张卡存在）
function s.tgfilter1(c,e,tp,zone)
	local can_sp = s.sp_filter(c,e,tp,zone)
	local can_td = s.td_filter(c)
	if not (can_sp or can_td) then return false end
	-- 寻找能互补的第二张卡
	return Duel.IsExistingTarget(s.tgfilter2, tp, LOCATION_GRAVE, 0, 1, c, e, tp, zone, can_sp, can_td)
end

-- 检查第2张卡（根据第1张卡的能力进行互补）
function s.tgfilter2(c,e,tp,zone,c1_can_sp,c1_can_td)
	local can_sp = s.sp_filter(c,e,tp,zone)
	local can_td = s.td_filter(c)
	-- 如果卡1能特召，卡2能回卡组，或者相反，皆为合法互补
	return (c1_can_sp and can_td) or (c1_can_td and can_sp)
end

function s.eff2tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end -- 手动多选，屏蔽自动取单对象
	local zone = Duel.GetLinkedZone(tp)
	
	if chk==0 then return Duel.IsExistingTarget(s.tgfilter1, tp, LOCATION_GRAVE, 0, 1, nil, e, tp, zone) end
	
	-- 第一步：选第一张
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g1 = Duel.SelectTarget(tp, s.tgfilter1, tp, LOCATION_GRAVE, 0, 1, 1, nil, e, tp, zone)
	local tc1 = g1:GetFirst()
	local c1_can_sp = s.sp_filter(tc1, e, tp, zone)
	local c1_can_td = s.td_filter(tc1)
	
	-- 第二步：选与之互补的第二张
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g2 = Duel.SelectTarget(tp, s.tgfilter2, tp, LOCATION_GRAVE, 0, 1, 1, tc1, e, tp, zone, c1_can_sp, c1_can_td)
	
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,tp,LOCATION_GRAVE) -- 包含发动的本卡
end

function s.eff2op(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #tg~=2 then return end
	local zone=Duel.GetLinkedZone(tp)
	
	local tc1 = tg:GetFirst()
	local tc2 = tg:GetNext()
	
	local c1_sp = s.sp_filter(tc1, e, tp, zone)
	local c1_td = s.td_filter(tc1)
	local c2_sp = s.sp_filter(tc2, e, tp, zone)
	local c2_td = s.td_filter(tc2)
	
	local sp_card = nil
	local td_card = nil
	
	if c1_sp and c1_td and c2_sp and c2_td then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local spg = tg:Select(tp, 1, 1, nil)
		sp_card = spg:GetFirst()
		td_card = (sp_card==tc1) and tc2 or tc1
	elseif c1_sp and c2_td then
		sp_card = tc1
		td_card = tc2
	elseif c2_sp and c1_td then
		sp_card = tc2
		td_card = tc1
	else
		return 
	end
	
	if Duel.SendtoDeck(td_card, nil, SEQ_DECKSHUFFLE, REASON_EFFECT) > 0 and td_card:IsLocation(LOCATION_DECK+LOCATION_EXTRA) then
		if Duel.SpecialSummon(sp_card, 0, tp, tp, false, false, POS_FACEUP, zone) > 0 then
			local c=e:GetHandler()
			if c:IsRelateToEffect(e) then
				Duel.BreakEffect()
				Duel.SendtoDeck(c, nil, SEQ_DECKSHUFFLE, REASON_EFFECT)
			end
		end
	end
end