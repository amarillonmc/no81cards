--裂潮落渊『如露如电』
local cm,m=GetID()
function cm.initial_effect(c)
	-- 【灵摆召唤】
	aux.EnablePendulumAttribute(c)
	-- 【灵摆效果】①：这张卡因发动的效果从场上离开的场合，作为代替把这张卡以及场上1张卡破坏。
	-- 参考【灵魂之像】的代替离场逻辑
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EFFECT_SEND_REPLACE)
	e1:SetTarget(cm.reptg)
	e1:SetValue(cm.repval)
	c:RegisterEffect(e1)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e1:SetLabelObject(g)
	-- 【怪兽效果】①：双方回合，把手卡的这张卡和卡组1只「落渊」灵摆怪兽表侧加入额外卡组才能发动...
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11452063,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCost(cm.m_cost)
	e2:SetTarget(cm.m_target)
	e2:SetOperation(cm.m_operation)
	c:RegisterEffect(e2)
end
-- =========================================
-- 灵摆效果相关函数
-- =========================================
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if not (eg:IsContains(c) and re and re:IsActivated() and bit.band(r,REASON_EFFECT)~=0 and c:GetDestination()&LOCATION_ONFIELD==0 and (c:IsLocation(LOCATION_PZONE) or c:GetOriginalCode()~=m)) then return end
		local dg=Duel.GetMatchingGroup(function(c) return c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_BATTLE_DESTROYED) end,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
		dg:KeepAlive()
		cm[e]=dg
		return c:IsDestructable(e) or #dg>0
	end
	local container=e:GetLabelObject()
	container:Clear()
	-- 将自身加入代替离场容器
	container:AddCard(c)
	Duel.HintSelection(container)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
	local dg=cm[e]
	if not dg or aux.GetValueType(dg)~="Group" then dg=Duel.GetMatchingGroup(function(c) return c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_BATTLE_DESTROYED) end,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c) end 
	local g=dg:Select(tp,1,1,nil)
	dg:DeleteGroup()
	cm[e]=nil
	if #g>0 then
		Duel.HintSelection(g)
		g:AddCard(c)
	end
	--c:SetStatus(STATUS_DESTROY_CONFIRMED,true)
	--g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
	Duel.Destroy(g,REASON_EFFECT+REASON_REPLACE)
	if Duel.GetOperatedGroup():IsContains(g:GetFirst()) and eg:IsContains(g:GetFirst()) then container:Merge(g) end
	return true
end
function cm.repval(e,c)
	return e:GetLabelObject():IsContains(c)
end
-- =========================================
-- 怪兽效果相关函数
-- =========================================
function cm.costfilter(c)
	return c:IsSetCard(0x5978) and c:IsType(TYPE_PENDULUM) and c:IsType(TYPE_MONSTER)
end
function cm.m_cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then 
		return c:IsType(TYPE_PENDULUM) 
		and Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_DECK,0,1,nil) 
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOEXTRA)
	local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_DECK,0,1,1,nil)
	g:AddCard(c)
	-- 【SendtoExtraP】：将手卡和卡组的灵摆怪兽表侧表示送入额外卡组
	Duel.SendtoExtraP(g,tp,REASON_COST)
end
function cm.tfilter(c)
	-- 范围调整：只有场上、墓地、除外状态的卡
	return c:IsAbleToDeck() and (c:IsLocation(LOCATION_ONFIELD) or c:IsLocation(LOCATION_GRAVE) or c:IsLocation(LOCATION_REMOVED))
end
function cm.m_target(e,tp,eg,ep,ev,re,r,rp,chk)
	local t=0
	if Duel.IsPlayerAffectedByEffect(tp,11452071) then
		t=LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED
	end
	local g=Duel.GetMatchingGroup(cm.tfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,t,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
end
function cm.thfilter(c)
	return c:IsSetCard(0x5978) and c:IsAbleToHand()
end
function cm.m_operation(e,tp,eg,ep,ev,re,r,rp)
	local count = 0
	local t=0
	if Duel.IsPlayerAffectedByEffect(tp,11452071) then
		Duel.IsPlayerAffectedByEffect(tp,11452071):UseCountLimit(tp)
		t=LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED
	end
	local g = Duel.GetMatchingGroup(cm.tfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,t,nil)
	if aux.NecroValleyNegateCheck(g) then return end
	-- 【核心洗牌循环】（沿用上一次的 #og 高级判定技巧）
	while #g > 0 do
		if count>0 then Duel.BreakEffect() end
		local lv=0
		local fg,gg,rg,exg=g:Filter(Card.IsLocation,nil,LOCATION_ONFIELD),g:Filter(Card.IsLocation,nil,LOCATION_GRAVE),g:Filter(Card.IsLocation,nil,LOCATION_REMOVED),g:Filter(Card.IsLocation,nil,LOCATION_EXTRA)
		GRAVILOID_COUNTER=count
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		local og = Duel.GetOperatedGroup()
		-- 检测真正被洗回卡组/额外卡组的卡片数量（过滤掉全抗怪等未成功移动的卡）
		local ct = #og
		if ct>0 or #fg~=fg:FilterCount(Card.IsLocation,nil,LOCATION_ONFIELD) or #gg~=gg:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE) or #rg~=rg:FilterCount(Card.IsLocation,nil,LOCATION_REMOVED) or #exg~=exg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA) then
			count = count + 1
			if GRAVILOID_COUNTER then e:GetHandler():SetTurnCounter(count) GRAVILOID_COUNTER=nil end
		else
			GRAVILOID_COUNTER=nil
			break 
		end
		-- 重复检测是否有新卡进入范围（如超量素材掉落）
		g = Duel.GetMatchingGroup(cm.tfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,t,nil)
	end
	-- 【落渊卡检索处理】
	if count > 0 then
		local restrict_flag = m * 10 + count
		-- 裁定：如果该数字本回合用过，后续效果不处理
		if Duel.GetFlagEffect(tp,restrict_flag) > 0 then return end
		local ag = Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)
		-- 裁定：检索数量必须足够
		if #ag >= count then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg = ag:Select(tp,count,count,nil)
			if #sg > 0 then
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
			end
			Duel.RegisterFlagEffect(tp, restrict_flag, RESET_PHASE+PHASE_END, 0, 1)
			
			-- 2. 处理统合版客户端提示（仅当 1~4 张时状态会发生改变）
			if count <= 4 then
				-- 组合状态计算 (1~15)
				local state = 0
				if Duel.GetFlagEffect(tp, m * 10 + 1) > 0 then state = state | 1 end
				if Duel.GetFlagEffect(tp, m * 10 + 2) > 0 then state = state | 2 end
				if Duel.GetFlagEffect(tp, m * 10 + 3) > 0 then state = state | 4 end
				if Duel.GetFlagEffect(tp, m * 10 + 4) > 0 then state = state | 8 end
				
				-- 利用底层等价原理，直接一键抹除旧的统合提示
				Duel.ResetFlagEffect(tp, m+0xffffff)
				
				-- 注册全新的统合提示
				if state > 0 then
					local de = Effect.CreateEffect(e:GetHandler())
					-- 【完美避开 6 号位映射】：状态 1~6 减1对应 0~5；状态 7~15 原样对应 7~15
					local desc_id = state <= 6 and (state - 1) or state
					de:SetDescription(aux.Stringid(m, desc_id))
					de:SetType(EFFECT_TYPE_FIELD)
					-- 这里的 Code 用 m 独立占位，专职负责显示提示，与 restrict_flag 解耦
					de:SetCode(EFFECT_FLAG_EFFECT+m+0xffffff) 
					de:SetProperty(EFFECT_FLAG_PLAYER_TARGET + EFFECT_FLAG_CLIENT_HINT)
					de:SetTargetRange(1,0)
					de:SetReset(RESET_PHASE+PHASE_END)
					Duel.RegisterEffect(de, tp)
				end
			-- 2. 处理统合版客户端提示（仅当 1~4 张时状态会发生改变）
			elseif count <= 7 then
				-- 组合状态计算 (1~15)
				for i=5,7 do
					local state = 0
					if Duel.GetFlagEffect(tp, 114520600 + i) > 0 then state = state | 1 end
					if Duel.GetFlagEffect(tp, 114520610 + i) > 0 then state = state | 2 end
					if Duel.GetFlagEffect(tp, 114520620 + i) > 0 then state = state | 4 end
					
					-- 利用底层等价原理，直接一键抹除旧的统合提示
					Duel.ResetFlagEffect(tp, 11452060+0xffffff+i)
					
					-- 注册全新的统合提示
					if state > 0 then
						local de = Effect.CreateEffect(e:GetHandler())
						-- 【完美避开 6 号位映射】：状态 1~6 减1对应 0~5；状态 7~15 原样对应 7~15
						local desc_id = 6 + state
						de:SetDescription(aux.Stringid(11452061+i, desc_id))
						de:SetType(EFFECT_TYPE_FIELD)
						-- 这里的 Code 用 m 独立占位，专职负责显示提示，与 restrict_flag 解耦
						de:SetCode(EFFECT_FLAG_EFFECT+11452060+0xffffff+i) 
						de:SetProperty(EFFECT_FLAG_PLAYER_TARGET + EFFECT_FLAG_CLIENT_HINT)
						de:SetTargetRange(1,0)
						de:SetReset(RESET_PHASE+PHASE_END)
						Duel.RegisterEffect(de, tp)
					end
				end
			end
		end
	end
end