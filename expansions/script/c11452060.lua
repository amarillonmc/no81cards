--临界落渊『诸行无常』
local cm,m=GetID()
function cm.initial_effect(c)
	-- 【灵摆召唤】
	aux.EnablePendulumAttribute(c)
	-- 【灵摆效果】①：灵摆区域的这张卡从场上离开的场合除外。
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCondition(cm.p_repcon)
	e1:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e1)
	-- 【灵摆效果】①续：那个回合，陷阱卡的发动从手卡也能用（双方生效）。
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCondition(cm.p_buffcon)
	e2:SetOperation(cm.p_buffop)
	c:RegisterEffect(e2)
	-- 【怪兽效果】①：双方回合，把手卡的这张卡和卡组1张「落渊」魔法卡除外才能发动...
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_TODECK)
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
function cm.p_repcon(e)
	return e:GetHandler():IsLocation(LOCATION_PZONE)
end
function cm.p_buffcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	-- 确认是从灵摆区离开，且最终落点是被除外
	return c:IsPreviousLocation(LOCATION_PZONE) and c:IsLocation(LOCATION_REMOVED)
end
function cm.p_buffop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	-- 赋予全局“手卡发陷阱”Buff
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,5))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
-- =========================================
-- 怪兽效果相关函数
-- =========================================
function cm.cfilter(c)
	return c:IsSetCard(0x5978) and c:IsType(TYPE_SPELL) and c:IsAbleToRemoveAsCost()
end
function cm.m_cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() 
		and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_DECK,0,1,1,nil)
	g:AddCard(c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.tfilter(c)
	return c:IsAbleToDeck() and (c:IsLocation(LOCATION_ONFIELD) or c:IsLocation(LOCATION_GRAVE) or (c:IsLocation(LOCATION_EXTRA) and c:IsFaceup()))
end
function cm.m_target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.tfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA,0,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA)
end
function cm.actfilter(c,tp)
	-- 类似于虚拟世界/真龙的“置入场上发动”
	return c:IsSetCard(0x5978) and c:GetActivateEffect():IsActivatable(tp) --not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function cm.m_operation(e,tp,eg,ep,ev,re,r,rp)
	local count = 0
	local t=0
	if Duel.IsPlayerAffectedByEffect(tp,11452071) then
		Duel.IsPlayerAffectedByEffect(tp,11452071):UseCountLimit(tp)
		t=LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA
	end
	local g = Duel.GetMatchingGroup(cm.tfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA,t,nil)
	if aux.NecroValleyNegateCheck(g) then return end
	-- 【核心洗牌循环】
	while g:GetCount() > 0 do
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
		-- 重新获取符合条件的卡，例如掉落进墓地的超量素材
		g = Duel.GetMatchingGroup(cm.tfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA,t,nil)
	end
	-- 【落渊卡发动处理】
	if count > 0 then
		-- 动态自肃Flag（m*100 + count作为唯一标识符，防止数字撞车）
		local restrict_flag = m * 10 + count
		-- 裁定：如果这个数字本回合已经用过，后续效果不处理
		if Duel.GetFlagEffect(tp,restrict_flag) > 0 then return end
		local ag = Duel.GetMatchingGroup(cm.actfilter,tp,LOCATION_DECK,0,nil,tp)
		local ft = Duel.GetLocationCount(tp,LOCATION_SZONE)
		local pft = 0
		if Duel.CheckLocation(tp,LOCATION_PZONE,0) then pft = pft + 1 end
		if Duel.CheckLocation(tp,LOCATION_PZONE,1) then pft = pft + 1 end
		-- 裁定：如果数量不足，后续效果不处理
		if ag:CheckSubGroup(function(g) return g:FilterCount(Card.IsType,nil,TYPE_FIELD)<=1 and g:FilterCount(Card.IsType,nil,TYPE_PENDULUM)<=pft and #g-g:FilterCount(Card.IsType,nil,TYPE_FIELD)<=ft end,count,count) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
			local sg = ag:SelectSubGroup(tp,function(g) return g:FilterCount(Card.IsType,nil,TYPE_FIELD)<=1 and g:FilterCount(Card.IsType,nil,TYPE_PENDULUM)<=pft and #g-g:FilterCount(Card.IsType,nil,TYPE_FIELD)<=ft end,false,count,count)
			local psg = sg:Filter(Card.IsType,nil,TYPE_PENDULUM)
			for tc in aux.Next(psg) do
				Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
				local te=tc:GetActivateEffect()
				local tep=tc:GetControler()
				local cost=te:GetCost()
				if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			end
			for tc in aux.Next(sg-psg) do
				if tc:IsType(TYPE_FIELD) then
					local fc = Duel.GetFieldCard(tp,LOCATION_SZONE,5)
					if fc then
						Duel.SendtoGrave(fc,REASON_RULE)
					end
					Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
				else
					Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
				end
				local te=tc:GetActivateEffect()
				local tep=tc:GetControler()
				local cost=te:GetCost()
				if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			end
			-- 记录自肃：本回合不能再发动相同数量
			if count>4 then
				Duel.RegisterFlagEffect(tp,restrict_flag,RESET_PHASE+PHASE_END,0,1)
			else
				local de=Effect.CreateEffect(e:GetHandler())
				de:SetDescription(aux.Stringid(m,count))
				de:SetType(EFFECT_TYPE_FIELD)
				de:SetCode(EFFECT_FLAG_EFFECT+restrict_flag)
				de:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
				de:SetTargetRange(1,0)
				de:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(de,tp)
			end
		end
	end
end