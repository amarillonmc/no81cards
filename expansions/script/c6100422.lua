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
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.acttg)
	e1:SetOperation(s.effop)
	c:RegisterEffect(e1)

	--②：作为同调素材离场，变成抽卡
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,4)) -- "变更效果为抽卡"
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(s.mtcon)
	e2:SetTarget(s.mttg)
	e2:SetOperation(s.mtop)
	c:RegisterEffect(e2)
end

-- === 效果①：条件与目标 ===
function s.spellfilter(c)
	if not c:IsType(TYPE_SPELL) then return false end
	if c:IsLocation(LOCATION_REMOVED) and c:IsFacedown() then return false end
	return true
end

function s.thfilter(c,ec)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand() and c~=ec
end

function s.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	
	local b1 = Duel.GetFlagEffect(tp,id)==0 and Duel.IsPlayerCanDraw(tp,1) 
		and Duel.IsExistingMatchingCard(s.spellfilter, tp, LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED, 0, 1, c)
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
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	elseif op==1 then
		Duel.RegisterFlagEffect(tp,id+1,RESET_PHASE+PHASE_END,0,1)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,0,LOCATION_ONFIELD)
	end
end

-- === 选项1 专属的组合验证器 ===
-- 限制所选卡片组合：每个区域最多只能存在1张
function s.gcheck(g)
	return g:FilterCount(Card.IsLocation, nil, LOCATION_HAND) <= 1
		and g:FilterCount(Card.IsLocation, nil, LOCATION_ONFIELD) <= 1
		and g:FilterCount(Card.IsLocation, nil, LOCATION_GRAVE) <= 1
		and g:FilterCount(Card.IsLocation, nil, LOCATION_REMOVED) <= 1
end

-- === 效果①：处理分歧 ===
function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	local c=e:GetHandler()
	
if op==0 then
	-- ● 选项1：各区域选卡，确认，洗切置顶/置底，按比例抽卡并赋予记述
	local cg = Duel.GetMatchingGroup(s.spellfilter, tp, LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED, 0, c)
	if #cg == 0 then return end
	
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TODECK)
	-- 一键选卡，最少1张，最多4张
	local tg = cg:SelectSubGroup(tp, s.gcheck, false, 1, 4)
	
	if tg and #tg > 0 then
		-- 向对方全部公开（包括里侧除外、盖放的魔法卡）
		Duel.ConfirmCards(1-tp, tg)
		
		-- 询问玩家放回卡组的方向
		local opt = Duel.SelectOption(tp, aux.Stringid(id, 5), aux.Stringid(id, 6))
		local draw_ct = tg:FilterCount(Card.IsLocation, nil, LOCATION_HAND+LOCATION_ONFIELD)
		Duel.SendtoDeck(tg, nil, SEQ_DECKSHUFFLE, REASON_EFFECT)
		local og = Duel.GetOperatedGroup():Filter(Card.IsLocation, nil, LOCATION_DECK+LOCATION_EXTRA)
		local ct = #og
		
		if ct > 0 then
			if opt == 0 then
				-- 随机抽取并暴力置于顶端，模拟“暗盘置顶洗切”
				for i=1, ct do
					local tc = (i < ct) and og:RandomSelect(tp, 1):GetFirst() or og:GetFirst()
					Duel.MoveSequence(tc, SEQ_DECKTOP)
					og:RemoveCard(tc)
				end
			else
				-- 随机抽取并暴力置于底端
				for i=1, ct do
					local tc = (i < ct) and og:RandomSelect(tp, 1):GetFirst() or og:GetFirst()
					Duel.MoveSequence(tc, SEQ_DECKBOTTOM)
					og:RemoveCard(tc)
				end
			end
			
			-- 抽从手卡·场上回到卡组的数量，并给对方观看
			if draw_ct > 0 and Duel.Draw(tp, draw_ct, REASON_EFFECT) > 0 then
				Duel.BreakEffect()
				local dg = Duel.GetOperatedGroup()
				Duel.ConfirmCards(1-tp, dg)
				Duel.ShuffleHand(tp)

				local mg = dg:Filter(Card.IsType, nil, TYPE_SPELL)
				for dc_tc in aux.Next(mg) do
					local code = dc_tc:GetOriginalCodeRule()
					local mt = _G["c"..code]
					if mt then
						if not mt.card_code_list then mt.card_code_list = {} end
						mt.card_code_list[6100146] = true
						
						-- 为该同名卡打上可见的文本光环标记
						local ag = Duel.GetMatchingGroup(Card.IsOriginalCodeRule, tp, 0xff, 0xff, nil, code)
						for ac in aux.Next(ag) do
							ac:RegisterFlagEffect(0, RESET_EVENT+RESETS_STANDARD, EFFECT_FLAG_CLIENT_HINT, 1, 0, aux.Stringid(id,4))
						end
					end
				end
			end
		end
	end
		
	elseif op==1 then
		-- ● 选项2：这张卡和另外1张魔陷回手
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