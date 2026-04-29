--辉色追忆 未达的信件
local s,id,o=GetID()
function s.initial_effect(c)
	--必须记述的卡号声明
	aux.AddCodeList(c,6100146)

	--发动后继续留在场上
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e0)

	--①：卡片的发动 (二选一)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.acttg)
	e1:SetOperation(s.effop)
	c:RegisterEffect(e1)

	--②：作为同调素材离场，改写效果为抽卡
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,5)) -- "变更对方效果为抽卡"
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(s.mtcon)
	e2:SetTarget(s.mttg)
	e2:SetOperation(s.mtop)
	c:RegisterEffect(e2)
end

-- === 效果①：条件与目标 ===
function s.filterA(c,ec)
	if c==ec then return false end
	-- 判定表侧与里侧的真实卡片类型
	local ty = c:GetType()
	if c:IsFacedown() then ty = c:GetOriginalType() end
	return (ty & TYPE_SPELL)~=0 and c:IsAbleToDeck()
end

function s.filterB(c)
	return c:IsType(TYPE_SPELL) and aux.IsCodeListed(c,6100146) and c:IsAbleToDeck()
end

function s.thfilter(c,ec)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand() and c~=ec
end

-- 子组验证器：确保手卡/场上的组选完后，卡组里一定有足量且完全不同名的牌可用
function s.gcheckA(sgA, gB)
	if not aux.dncheck(sgA) then return false end
	local count = #sgA
	-- 从卡组候选群中，剔除所有和 sgA 里同名的卡
	local valid_B = gB:Filter(function(c) return not sgA:IsExists(Card.IsCode, 1, nil, c:GetCode()) end, nil)
	-- 如果剔除后，卡组里剩余的不同名卡种类数量 >= sgA的数量，则代表这套组合合法
	return valid_B:GetClassCount(Card.GetCode) >= count
end

function s.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	
	local b1 = false
	if Duel.GetFlagEffect(tp,id)==0 and Duel.IsPlayerCanDraw(tp, 1) then
		local gA = Duel.GetMatchingGroup(s.filterA, tp, LOCATION_HAND+LOCATION_ONFIELD, 0, c, c)
		local gB = Duel.GetMatchingGroup(s.filterB, tp, LOCATION_DECK, 0, nil)
		-- 预检：至少有一张 A 和一张 B 不同名
		for cA in aux.Next(gA) do
			if gB:IsExists(function(cB) return cB:GetCode() ~= cA:GetCode() end, 1, nil) then
				b1 = true
				break
			end
		end
	end
	
	local b2 = Duel.GetFlagEffect(tp,id+1)==0 
		and Duel.IsExistingMatchingCard(s.thfilter, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, 1, c, c)
		
	if chk==0 then return b1 or b2 end 
	
	local op=0
	if b1 and b2 then
		local sel=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
		op=sel
	elseif b1 then
		Duel.SelectOption(tp,aux.Stringid(id,1))
		op=0
	else
		Duel.SelectOption(tp,aux.Stringid(id,2))
		op=1
	end
	e:SetLabel(op)
	
	if op==0 then
	e:SetCategory(CATEGORY_TOHAND+CATEGORY_DRAW)
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_DECK)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	elseif op==1 then
		Duel.RegisterFlagEffect(tp,id+1,RESET_PHASE+PHASE_END,0,1)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,0,LOCATION_ONFIELD)
	end
end

-- === 效果①：处理分歧 ===
function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	local c=e:GetHandler()
	
	if op==0 then
		-- ● 选项1：选出两边，确认洗切抽卡
		local gA = Duel.GetMatchingGroup(s.filterA, tp, LOCATION_HAND+LOCATION_ONFIELD, 0, c, c)
		local gB = Duel.GetMatchingGroup(s.filterB, tp, LOCATION_DECK, 0, nil)
		if #gA == 0 or #gB == 0 then return end
		
		Duel.Hint(HINT_SELECTMSG, tp, aux.Stringid(id, 3)) -- "选择手卡·场上的魔法卡"
		local sel_A = gA:SelectSubGroup(tp, s.gcheckA, false, 1, 99, gB)
		Duel.ConfirmCards(1-tp,sel_A)
		if not sel_A or #sel_A == 0 then return end
		
		local count = #sel_A
		local valid_B = gB:Filter(function(tc) return not sel_A:IsExists(Card.IsCode, 1, nil, tc:GetCode()) end, nil)
		
		Duel.Hint(HINT_SELECTMSG, tp, aux.Stringid(id, 4)) -- "选择卡组的魔法卡"
		local sel_B = valid_B:SelectSubGroup(tp, aux.dncheck, false, count, count)
		if not sel_B or #sel_B ~= count then return end
		
		local sg = sel_A:Clone()
		sg:Merge(sel_B)
		
		-- 确认全套阵容
		Duel.ConfirmCards(1-tp, sg)
		
		-- 【核心修正】：只对来自手卡和场上的卡执行送回卡组的动作
		Duel.DisableShuffleCheck()
		Duel.SendtoDeck(sel_A, nil, SEQ_DECKTOP, REASON_EFFECT)
		
		-- 重新提取我们选中的全部卡片（此时它们必须全都在卡组里）
		local tg = sg:Filter(Card.IsLocation, nil, LOCATION_DECK)
		local ct = #tg
		
		if ct > 0 then
			for i=1, ct do
				local tc
				if i < ct then
					tc = tg:RandomSelect(tp, 1):GetFirst()
				else
					tc = tg:GetFirst()
				end
				Duel.MoveSequence(tc, SEQ_DECKTOP)
				tg:RemoveCard(tc)
			end
			
			local draw_ct = sel_A:FilterCount(Card.IsLocation, nil, LOCATION_DECK)
			
			if draw_ct > 0 then
				Duel.Draw(tp, draw_ct, REASON_EFFECT)
			end
		end

	elseif op==1 then
		-- ● 选项2：这张卡和场上1张魔陷回手
		if not c:IsRelateToEffect(e) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c,c)
		Duel.HintSelection(g)
		if #g>0 then
			g:AddCard(c)
			c:CancelToGrave() 
			Duel.SendtoHand(g,nil,REASON_EFFECT)
		end
	end
end

-- === 效果②：同调素材离场，改写对方加手效果 ===
function s.mtcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return r==REASON_SYNCHRO and c:IsPreviousLocation(LOCATION_ONFIELD)
end

function s.mttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end

function s.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFlagEffect(1-tp,id+100)>0 then return false end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetOperation(s.changeop)
	Duel.RegisterEffect(e1, tp)
	Duel.RegisterFlagEffect(1-tp,id+100,nil,0,1)
end

function s.changeop(e,tp,eg,ep,ev,re,r,rp)
	if rp ~= 1-tp then return end
	-- 判定对方发动的效果是否包含“把卡加入手卡”分类
	local is_add = false
	local ex1 = Duel.GetOperationInfo(ev, CATEGORY_TOHAND)
	local ex2 = Duel.GetOperationInfo(ev, CATEGORY_SEARCH)
	local ex3 = Duel.GetOperationInfo(ev, CATEGORY_DRAW)
	
	if ex1 or ex2 or ex3 then
		is_add = true
	end
	if re:IsHasCategory(CATEGORY_TOHAND) or re:IsHasCategory(CATEGORY_SEARCH) or re:IsHasCategory(CATEGORY_DRAW) and re:IsActivated() then
		is_add = true
	end
	
	if is_add then
		Duel.Hint(HINT_CARD,0,id)
		Duel.ChangeChainOperation(ev, s.repop)
		e:Reset() -- 拦截一次即完成任务并自我销毁
		Duel.ResetFlagEffect(1-tp,id+100)
	end
end

function s.repop(e,tp,eg,ep,ev,re,r,rp)
	-- 效果被改写为：“双方各自从卡组抽1张”
	Duel.Draw(tp, 1, REASON_EFFECT)
	Duel.Draw(1-tp, 1, REASON_EFFECT)
end