--殉星落渊『一莲托生』
local cm,m=GetID()
function cm.initial_effect(c)
	if not Auxiliary.PendulumChecklist then
		Auxiliary.PendulumChecklist=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge1:SetOperation(Auxiliary.PendulumReset)
		Duel.RegisterEffect(ge1,0)
	end
	local e01=Effect.CreateEffect(c)
	e01:SetDescription(1163)
	e01:SetType(EFFECT_TYPE_FIELD)
	e01:SetCode(EFFECT_SPSUMMON_PROC_G)
	e01:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e01:SetRange(LOCATION_PZONE)
	e01:SetCondition(Auxiliary.PendCondition)
	e01:SetOperation(Auxiliary.PendOperation)
	e01:SetValue(SUMMON_TYPE_PENDULUM)
	c:RegisterEffect(e01)
	local e02=Effect.CreateEffect(c)
	e02:SetDescription(1160)
	e02:SetType(EFFECT_TYPE_ACTIVATE)
	e02:SetCode(EVENT_FREE_CHAIN)
	e02:SetRange(LOCATION_HAND)
	e02:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
					local c=e:GetHandler()
					if chk==0 then return true end
					if c:IsStatus(STATUS_EFFECT_ENABLED) and Duel.IsChainSolving() then e:SetLabel(1) end
				end)
	c:RegisterEffect(e02)
	-- 【灵摆效果】①：这张卡的发动后把1张手卡持续公开。
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetRange(LOCATION_SZONE)
	e1:SetLabelObject(e02)
	e1:SetCondition(cm.pc_con)
	e1:SetOperation(cm.pc_op)
	c:RegisterEffect(e1)
	-- 【灵摆效果】①续：这张卡从场上离开时那张卡破坏，自己抽1张。
	local e20=Effect.CreateEffect(c)
	e20:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e20:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e20:SetCode(EVENT_LEAVE_FIELD_P)
	e20:SetOperation(cm.checkop)
	c:RegisterEffect(e20)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetLabelObject(e20)
	e2:SetCondition(cm.descon)
	e2:SetOperation(cm.desop)
	c:RegisterEffect(e2)
	-- 【怪兽效果】①：双方回合，把手卡的这张卡和卡组1张「落渊」陷阱卡送去墓地才能发动...
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11452063,1))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_HAND)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetCost(cm.m_cost)
	e3:SetTarget(cm.m_target)
	e3:SetOperation(cm.m_operation)
	c:RegisterEffect(e3)
end
-- =========================================
-- 灵摆效果相关函数
-- =========================================
function cm.pc_con(e,tp,eg,ep,ev,re,r,rp)
	if not (e:GetHandler():IsLocation(LOCATION_PZONE) or e:GetHandler():GetOriginalCode()~=m) then return false end
	-- 确认是这张卡作为魔法卡发动成功后的时点
	if e:GetLabelObject():GetLabel()==1 then
		e:GetLabelObject():SetLabel(0)
		return true
	end
	return re:GetHandler()==e:GetHandler() and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cm.pc_op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.HintSelection(Group.FromCards(c))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		-- 建立类似“活死人的呼声”的对象关系
		local fid=c:GetFieldID()
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		Duel.ConfirmCards(1-tp,tc)
		-- 注册持续公开效果与客户端提示
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetDescription(aux.Stringid(11452063,3)) -- 建议在字符串配置中写 "已公开"
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabel(0)
	local lab=e:GetHandler():GetFlagEffectLabel(m)
	if not e:GetHandler():IsDisabled() and lab then e:SetLabel(lab) end
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lab=e:GetLabelObject():GetLabel()
	-- 确认从灵摆区离开，且存在取对象的卡
	return c:IsPreviousLocation(LOCATION_PZONE) and lab>0 and Duel.IsExistingMatchingCard(function(c) return c:GetFlagEffect(m)>0 and c:GetFlagEffectLabel(m)==lab end,tp,LOCATION_HAND,0,1,nil)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local lab=e:GetLabelObject():GetLabel()
	local g=Duel.GetMatchingGroup(function(c) return c:GetFlagEffect(m)>0 and c:GetFlagEffectLabel(m)==lab end,tp,LOCATION_HAND,0,nil)
	-- 如果目标卡还在手卡，则破坏并抽卡
	if Duel.Destroy(g,REASON_EFFECT)>0 then
		Duel.Draw(tp,#g,REASON_EFFECT)
	end
end
-- =========================================
-- 怪兽效果相关函数
-- =========================================
function cm.m_cost_filter(c)
	return c:IsSetCard(0x5978) and c:IsType(TYPE_TRAP) and c:IsAbleToGraveAsCost()
end
function cm.m_cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() 
		and Duel.IsExistingMatchingCard(cm.m_cost_filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.m_cost_filter,tp,LOCATION_DECK,0,1,1,nil)
	g:AddCard(c)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.tfilter(c)
	-- 注意修改点：额外卡组（表侧）、场上、除外状态
	return c:IsAbleToDeck() and (c:IsLocation(LOCATION_ONFIELD) or c:IsLocation(LOCATION_REMOVED) or (c:IsLocation(LOCATION_EXTRA) and c:IsFaceup()))
end
function cm.m_target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.tfilter,tp,LOCATION_ONFIELD+LOCATION_REMOVED+LOCATION_EXTRA,0,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,LOCATION_ONFIELD+LOCATION_REMOVED+LOCATION_EXTRA)
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x5978) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.m_operation(e,tp,eg,ep,ev,re,r,rp)
	local count = 0
	local t=0
	if Duel.IsPlayerAffectedByEffect(tp,11452071) then
		Duel.IsPlayerAffectedByEffect(tp,11452071):UseCountLimit(tp)
		t=LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA
	end
	local g = Duel.GetMatchingGroup(cm.tfilter,tp,LOCATION_ONFIELD+LOCATION_REMOVED+LOCATION_EXTRA,t,nil)
	if aux.NecroValleyNegateCheck(g) then return end
	-- 【核心洗牌循环】
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
		-- 重新获取符合条件的卡
		g = Duel.GetMatchingGroup(cm.tfilter,tp,LOCATION_ONFIELD+LOCATION_REMOVED+LOCATION_EXTRA,t,nil)
	end
	-- 【落渊怪兽特召处理】
	if count > 0 then
		-- 动态自肃Flag
		local restrict_flag = m * 10 + count
		-- 裁定：如果这个数字本回合已经用过，后续效果不处理
		if Duel.GetFlagEffect(tp,restrict_flag) > 0 then return end
		local ag = Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
		local ft = Duel.GetLocationCount(tp,LOCATION_MZONE)
		-- 青眼精灵龙（同时特召2只以上的限制）检测
		local is_spirit = Duel.IsPlayerAffectedByEffect(tp,59822133)
		-- 裁定：如果数量不足、格子不够、或被精灵龙限制特召多个，则不处理
		if #ag >= count and ft >= count and not (is_spirit and count > 1) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg = ag:Select(tp,count,count,nil)
			if #sg > 0 then
				Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
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
			end
		end
	end
end