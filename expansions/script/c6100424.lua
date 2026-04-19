--辉色追忆 以太激荡
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

	--②：作为同调素材离场，检索并赋记述
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,4)) -- "检索并赋予卡名记述"
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(s.mtcon)
	e2:SetTarget(s.mttg)
	e2:SetOperation(s.mtop)
	c:RegisterEffect(e2)
end

-- === 效果①：条件与目标 ===
function s.rvfilter(c)
	return (c:IsCode(6100146) or (c:IsType(TYPE_SPELL) and aux.IsCodeListed(c,6100146))) and not c:IsPublic()
end

function s.thfilter1(c,ec)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand() and c~=ec
end

function s.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	
	local b1 = Duel.GetFlagEffect(tp,id)==0 
		and Duel.IsExistingMatchingCard(s.rvfilter, tp, LOCATION_HAND, 0, 1, c)
	local b2 = Duel.GetFlagEffect(tp,id+1)==0 
		and Duel.IsExistingMatchingCard(s.thfilter1, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, 1, c, c)
		
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
		-- 选项1只需要展示作为发动时的信息，无需 Category
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
		-- ● 选项1：展示，开启随机除外大宇宙
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=Duel.SelectMatchingCard(tp,s.rvfilter,tp,LOCATION_HAND,0,1,1,nil)
		if #g>0 then
			Duel.ConfirmCards(1-tp,g)
			Duel.ShuffleHand(tp)
			
			-- 注册劫持进入对方墓地的替换效果
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetCode(EFFECT_SEND_REPLACE)
			e1:SetTargetRange(0,0xff)
			e1:SetTarget(s.reptg)
			e1:SetValue(s.repval)
			e1:SetOperation(s.repop)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)

		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetTargetRange(0,LOCATION_ONFIELD)
		e2:SetValue(LOCATION_REMOVED)
		Duel.RegisterEffect(e2,tp)
			
			Duel.RegisterFlagEffect(tp,id+10,RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,3))
		end
		
	elseif op==1 then
		-- ● 选项2：这张卡和另外1张魔陷回手
		if not c:IsRelateToEffect(e) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=Duel.SelectMatchingCard(tp,s.thfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c,c)
		Duel.HintSelection(g)
		if #g>0 then
			g:AddCard(c)
			c:CancelToGrave() 
			Duel.SendtoHand(g,nil,REASON_EFFECT)
		end
	end
end

-- = 随机除外大宇宙的核心劫持 =
function s.repfilter(c,tp)
	-- 被送去对方墓地的卡 且 允许被除外
	return c:GetDestination()==LOCATION_GRAVE and c:GetOwner()==1-tp and c:IsAbleToRemove() and not c:IsLocation(LOCATION_ONFIELD)
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(s.repfilter,1,nil,tp) end
	-- 将符合条件的卡缓存，拦截进入墓地的动作
	if s.rep_group then s.rep_group:DeleteGroup() end
	local g=eg:Filter(s.repfilter,nil,tp)
	s.rep_group=g
	g:KeepAlive()
	return true
end
function s.repval(e,c)
	return s.repfilter(c,e:GetHandlerPlayer())
end

if not s.rng_state then s.rng_state=0 end

function s.repop(e,tp,eg,ep,ev,re,r,rp)
	local g=s.rep_group
	if not g then return end
	
	local mix_factor = Duel.GetLP(0) + Duel.GetLP(1) + Duel.GetTurnCount() + Duel.GetFieldGroupCount(0,0xff,0xff)
	s.rng_state = s.rng_state + mix_factor
	
	for tc in aux.Next(g) do
		-- 标准 LCG (线性同余) 伪随机算法
		s.rng_state = (s.rng_state * 1103515245 + 12345) & 0x7fffffff
		-- 取高位进行模2运算，得出 0 或 1
		local rand = (s.rng_state >> 16) % 2
		
		-- 0 为表侧，1 为里侧
		local pos = (rand == 0) and POS_FACEUP or POS_FACEDOWN
		Duel.Remove(tc, pos, REASON_EFFECT+REASON_REDIRECT)
	end
	
	g:DeleteGroup()
	s.rep_group=nil
end

-- === 效果②：同调素材离场，检索并赋记述 ===
function s.mtcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return r==REASON_SYNCHRO and c:IsPreviousLocation(LOCATION_ONFIELD)
end

function s.spell_filter(c)
	if not c:IsType(TYPE_SPELL) then return false end
	-- 除外区里侧的卡无法被确认类型
	if c:IsLocation(LOCATION_REMOVED) and c:IsFacedown() then return false end
	return true
end

function s.thfilter2(c)
	return aux.IsCodeListed(c, 6100146) and c:IsAbleToHand()
end

function s.gcheck(g)
	if not aux.dncheck(g) then return false end
	-- 组合合法性检验：这组卡里必须至少有1张能加手且记述了愚者，并且剩下的其他卡都必须能回卡组
	return g:IsExists(function(c, grp)
		if not s.thfilter2(c) then return false end
		for tc in aux.Next(grp) do
			if tc ~= c and not tc:IsAbleToDeck() then return false end
		end
		return true
	end, 1, nil, g)
end

function s.mttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(s.spell_filter, tp, LOCATION_GRAVE+LOCATION_REMOVED, 0, nil)
		-- 只要有一张记述了愚者的卡就能启动（选1的情况）
		return g:IsExists(s.thfilter2, 1, nil)
	end
	Duel.SetOperationInfo(0, CATEGORY_TODECK, nil, 0, tp, LOCATION_GRAVE+LOCATION_REMOVED)
end

function s.mtop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.spell_filter, tp, LOCATION_GRAVE+LOCATION_REMOVED, 0, nil)
	if #g==0 then return end
	
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_OPERATECARD)
	-- 最多选3张
	local sg=g:SelectSubGroup(tp, s.gcheck, false, 1, 3)
	
	if sg and #sg>0 then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SET)
		-- 玩家从选出的卡里，手动选一张记述了愚者的加入手卡
		local thg=sg:FilterSelect(tp, s.thfilter2, 1, 1, nil)
		if #thg>0 then
			Duel.SSet(tp,thg:GetFirst())
			
			sg:Sub(thg)
			if #sg>0 then
				Duel.SendtoDeck(sg, nil, SEQ_DECKSHUFFLE, REASON_EFFECT)
				local og=Duel.GetOperatedGroup():Filter(Card.IsLocation, nil, LOCATION_DECK+LOCATION_EXTRA)
				if #og>0 then
					for dc in aux.Next(og) do
						-- 底层核心元表改写黑科技
						local code = dc:GetOriginalCodeRule()
						local mt = _G["c"..code]
						if mt then
							if not mt.card_code_list then mt.card_code_list = {} end
							mt.card_code_list[6100146] = true
							
							-- 为该同名卡打上可见的文本标记，直至决斗结束
							local ag=Duel.GetMatchingGroup(Card.IsOriginalCodeRule,tp,0xff,0xff,nil,code)
							for ac in aux.Next(ag) do
								ac:RegisterFlagEffect(0,nil,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,4))
							end
						end
					end
				end
			end
		end
	end
end