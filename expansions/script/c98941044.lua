--伴随星遗物的灾厄
local s,id =GetID()
function c98941044.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCountLimit(1,98941044+EFFECT_COUNT_CODE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c98941044.target)
	e1:SetOperation(c98941044.activate)
	c:RegisterEffect(e1)	
	local e10=e1:Clone()
	e10:SetRange(LOCATION_DECK)
	e10:SetCondition(c98941044.con1)
	e10:SetCost(c98941044.cost)
	c:RegisterEffect(e10)
	local e30=Effect.CreateEffect(c)
	e30:SetType(EFFECT_TYPE_FIELD)
	e30:SetCode(EFFECT_ACTIVATE_COST)
	e30:SetRange(LOCATION_DECK+LOCATION_HAND)
	e30:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e30:SetTargetRange(1,0)
	e30:SetLabelObject(e10)
	e30:SetTarget(c98941044.actarget)
	e30:SetOperation(c98941044.costop)
	c:RegisterEffect(e30)
	local e3=e10:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_HAND)
	c:RegisterEffect(e3)
	-- search
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 5))
	e2:SetCategory(CATEGORY_TOHAND + CATEGORY_SEARCH + CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(s.thcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	--extra material
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e4:SetRange(LOCATION_EXTRA)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetValue(c98941044.matval)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e5:SetRange(0xff)
	e5:SetTargetRange(LOCATION_EXTRA,0)
	e5:SetCondition(c98941044.conex)
	e5:SetTarget(s.eftg)
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)
	--set
	local e24=Effect.CreateEffect(c)
	e24:SetDescription(aux.Stringid(id,0))
	e24:SetType(EFFECT_TYPE_QUICK_O)
	e24:SetCode(EVENT_FREE_CHAIN)
	e24:SetRange(LOCATION_HAND)
	e24:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e24:SetCondition(s.condition1)
	e24:SetTarget(s.target1)
	e24:SetOperation(s.grop_wrapper)
	local e25=Effect.CreateEffect(c)
	e25:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e25:SetRange(0xff)
	e25:SetTargetRange(LOCATION_HAND,0)
	e25:SetTarget(s.eftg1)
	e25:SetCondition(c98941044.conex1)
	e25:SetLabelObject(e24)
	c:RegisterEffect(e25)	

-- 创建一个全局弱引用表，用于存储被动态覆盖的Operation，防止内存泄漏
s.overridden_ops = s.overridden_ops or {}
setmetatable(s.overridden_ops, {__mode = "k"}) -- "k" 表示键（Effect对象）是弱引用的   

end
function s.limit_con(e)
	return e:GetHandler():IsLocation(LOCATION_HAND)
end
function s.eftg(e,c)
	return c:IsType(TYPE_LINK) and c:IsSetCard(0x10c)
end
function c98941044.conex(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(98941044)>0
end
function c98941044.conex1(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(tp,98941045)>0
end
function c98941044.matval(e,lc,mg,c,tp)
	if e:GetHandler()~=lc then return false,nil end
	return true,not mg or not mg:IsExists(Card.IsControler,1,nil,1-tp)
end
function c98941044.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tp=e:GetHandlerPlayer()
	Duel.RegisterFlagEffect(tp,98941045,RESET_PHASE+PHASE_END,0,1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetCondition(s.drcon)
	e2:SetOperation(s.drop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c98941044.ccfilter(c)
	return c:GetColumnGroupCount()>0
end
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	local zone=0
	local lg=Duel.GetMatchingGroup(c98941044.ccfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	for tc in aux.Next(lg) do
		zone=bit.bor(zone,tc:GetColumnZone(LOCATION_MZONE,tp))
	end
	return rp==tp and Duel.IsChainDisablable(ev) and Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
		and Duel.IsExistingMatchingCard(c98941044.xsfilter,tp,LOCATION_HAND,0,1,nil,zone)
end
function c98941044.xsfilter(c,zone)
	return c:IsSetCard(0x10c) and c:IsSpecialSummonableCard()
end
function c98941044.xxspfilter(c,zone)
	return c:IsSetCard(0x10c) and c:IsSpecialSummonableCard()
end
function c98941044.drrcfilter(c,tp)
	return c:IsControler(1-tp) and c:IsLocation(LOCATION_MZONE)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local zone=0
	local lg=Duel.GetMatchingGroup(c98941044.ccfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	for tc in aux.Next(lg) do
		zone=bit.bor(zone,tc:GetColumnZone(LOCATION_MZONE,tp))
	end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(id,4)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c98941044.xxspfilter,tp,LOCATION_HAND,0,1,1,nil,zone)
		if g:GetCount()>0 then
		   local tcc=g:GetFirst()
		   Duel.Hint(HINT_CARD,0,tcc:GetCode())
		   if Duel.SpecialSummon(tcc,0,tp,tp,false,false,POS_FACEUP,zone)~=0 then
			  if Duel.NegateEffect(ev) then
					 local ssg=tcc:GetColumnGroup():Filter(c98941044.drrcfilter,nil,tp)
					 if #ssg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,6)) then
						  Duel.Draw(tp,1,REASON_EFFECT) 
					 end
				end
			 end
		end
	end
end
function s.eftg1(e,c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0xfe)
end
-- 获取指定列的卡片数量
function s.get_column_count(tp,seq)
	local ct=0
	if Duel.GetFieldCard(tp,LOCATION_MZONE,seq) then ct=ct+1 end
	if Duel.GetFieldCard(1-tp,LOCATION_MZONE,4-seq) then ct=ct+1 end
	if Duel.GetFieldCard(tp,LOCATION_SZONE,seq) then ct=ct+1 end
	if Duel.GetFieldCard(1-tp,LOCATION_SZONE,4-seq) then ct=ct+1 end
	if seq==1 then
		if Duel.GetFieldCard(tp,LOCATION_MZONE,5) then ct=ct+1 end
		if Duel.GetFieldCard(1-tp,LOCATION_MZONE,6) then ct=ct+1 end
	end
	if seq==3 then
		if Duel.GetFieldCard(tp,LOCATION_MZONE,6) then ct=ct+1 end
		if Duel.GetFieldCard(1-tp,LOCATION_MZONE,5) then ct=ct+1 end
	end
	return ct
end

-- 获取可用（且卡数>=2）的魔陷区纵列
function s.get_usable_zone(tp)
	local zone=0
	for seq=0,4 do
		if s.get_column_count(tp,seq)>=1 and Duel.CheckLocation(tp,LOCATION_SZONE,seq) then
			zone=bit.bor(zone,1<<seq)
		end
	end
	return zone
end

function s.condition1(e,tp,eg,ep,ev,re,r,rp)
	-- 同一连锁上最多1次
	return Duel.GetFlagEffect(tp,e:GetHandler():GetCode()+1)==0
end

function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	local tp=e:GetHandlerPlayer()
	local zone=s.get_usable_zone(tp)
	if chk==0 then return zone>0 end
	-- 注册同连锁1次标志
	Duel.RegisterFlagEffect(tp,e:GetHandler():GetCode()+1,RESET_CHAIN,0,1)
	local te,ceg,cep,cev,cre,cr,crp=e:GetHandler():CheckActivateEffect(false,true,true)
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)  
	-- ====== 核心兼容性修复部分 ======
	-- 检查原本的 Target 函数是否在刚才执行时，偷偷改写了 e 的 Operation
	local current_op = e:GetOperation()
	if current_op ~= s.grop_wrapper then
		-- 记录被改写后的 Operation（即使被改写成了 nil 也会记录）
	s.overridden_ops[e] = { op = current_op }
		-- 强制将 Operation 还原为我们的包裹函数，确保“回到卡组最下方”能够执行
	e:SetOperation(s.grop_wrapper)
	end
end

function s.grop_wrapper(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local te=c:GetActivateEffect()
	if not c:IsRelateToEffect(e) then return end
	local zone=s.get_usable_zone(tp)
	if zone>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		if Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true,zone) then
			if not te then return end
	-- 获取真正应该执行的 Operation
			local op
			local info = s.overridden_ops[e]
			if info then
			   op = info.op -- 使用被动态改写的那个 Operation
			   s.overridden_ops[e] = nil -- 及时清理，防止表格膨胀
			else
			   op = te:GetOperation() -- 没被改写过，直接用原本卡片写好的 Operation
			end

	-- 1. 执行效果处理
			if op then
				  op(e,tp,eg,ep,ev,re,r,rp)
			end
		end
	end
end

function c98941044.con1(e)
	return s.get_valid_zones(tp) > 0
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
-- 1. 检测连锁条件：是否连锁了「字段码0xfe」的魔陷卡效果
	e:GetHandler():RegisterFlagEffect(98941044,RESET_CHAIN,0,1)
	local is_chained = false
	local e_chain = Duel.GetCurrentChain()
	-- 如果当前链大于1（说明本卡是连锁发动的）
	if e_chain > 1 then
		local pe = Duel.GetChainInfo(e_chain-1, CHAININFO_TRIGGERING_EFFECT)
		local pc = pe:GetHandler()
		if pc and pc:IsSetCard(0x10c,0xfe) then
			is_chained = true
		end
	end

	-- 2. chk == 0 时的合法性检测
	if chk == 0 then
		if not is_chained then
			-- 如果没有正确连锁，效果强制变为“手卡回卡组”，此时手卡必须有卡才能发动（或根据规则允许空手卡发动，这里设计为手卡必须有卡）
			return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,nil)
		else
			-- 如果正确连锁，检测3个效果中是否至少有1个可以发动
			-- 效果①可行性：双方场上都有格子，且能召唤衍生物
			local opt1 = Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
				and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
				and Duel.IsPlayerCanSpecialSummonMonster(tp,98941045,0x10c,0x4011,0,0,4,RACE_PSYCHO,ATTRIBUTE_LIGHT)
				and Duel.IsPlayerCanSpecialSummonMonster(1-tp,98941045,0x10c,0x4011,0,0,4,RACE_PSYCHO,ATTRIBUTE_LIGHT)
			-- 效果②可行性：额外卡组有可以连接召唤的0x10c怪兽
			local opt2 = Duel.IsExistingMatchingCard(s.lkfilter,tp,LOCATION_EXTRA,0,1,nil)
			-- 效果③可行性：场上/墓地/除外有至少7张对应的卡
			local opt3 = Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,7,nil)
			
			return opt1 or opt2 or opt3
		end
	end

	-- 3. 实际发动阶段的分类处理
	if not is_chained then
		-- 未满足连锁条件：标记为 0号效果（手卡全部回卡组）
		e:SetLabel(0)
		e:SetCategory(CATEGORY_TODECK)
		local g = Duel.GetFieldGroup(tp,LOCATION_HAND,0)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
	else
		-- 满足连锁条件：玩家进行3选1
		local opt1 = Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
			and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,98941045,0x10c,0x4011,0,0,4,RACE_PSYCHO,ATTRIBUTE_LIGHT)
			and Duel.IsPlayerCanSpecialSummonMonster(1-tp,98941045,0x10c,0x4011,0,0,4,RACE_PSYCHO,ATTRIBUTE_LIGHT)
		local opt2 = Duel.IsExistingMatchingCard(s.lkfilter,tp,LOCATION_EXTRA,0,1,nil)
		local opt3 = Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,7,nil)

		-- 动态构建选项菜单
		local ops = {}
		local sel = {}
		local i = 1
		if opt1 then
			ops[i] = aux.Stringid(id,1) -- 选项1：召唤衍生物
			sel[i] = 1
			i = i + 1
		end
		if opt2 then
			ops[i] = aux.Stringid(id,2) -- 选项2：进行连接召唤
			sel[i] = 2
			i = i + 1
		end
		if opt3 then
			ops[i] = aux.Stringid(id,3) -- 选项3：7张卡回卡组
			sel[i] = 3
			i = i + 1
		end

		local op = Duel.SelectOption(tp,table.unpack(ops)) + 1
		local choice = sel[op]
		e:SetLabel(choice)

		-- 根据玩家的选择设定Category和OperationInfo
		if choice == 1 then
			e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
			Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
			Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,0)
		elseif choice == 2 then
			e:SetCategory(CATEGORY_SPECIAL_SUMMON)
			Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
		elseif choice == 3 then
			e:SetCategory(CATEGORY_TODECK)
			local g = Duel.GetMatchingGroup(s.tdfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
			Duel.SetOperationInfo(0,CATEGORY_TODECK,g,7,0,0)
		end
	end
end
function s.lkfilter(c)
	return c:IsSetCard(0x10c) and c:IsType(TYPE_LINK) and c:IsLinkSummonable(nil)
end

-- 过滤器：过滤符合效果③的卡（场上表侧、墓地、除外状态的0x10c或0xfe卡片）
function s.tdfilter(c)
	if c:IsLocation(LOCATION_ONFIELD) and c:IsFacedown() then return false end
	return (c:IsSetCard(0x10c) or c:IsSetCard(0xfe)) and c:IsAbleToDeck()
end
function c98941044.activate(e,tp,eg,ep,ev,re,r,rp)
	local label = e:GetLabel()

	-- 惩罚效果：手卡全部回到卡组
	if label == 0 then
		local g = Duel.GetFieldGroup(tp,LOCATION_HAND,0)
		if #g > 0 then
			Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		end
		return
	end

	-- 效果●1：召唤衍生物
	if label == 1 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0 then return end
		if not Duel.IsPlayerCanSpecialSummonMonster(tp,98941045,0,0x10c,0,0,4,RACE_PSYCHO,ATTRIBUTE_LIGHT) then return end
		if not Duel.IsPlayerCanSpecialSummonMonster(1-tp,98941045,0,0x10c,0,0,4,RACE_PSYCHO,ATTRIBUTE_LIGHT) then return end
		
		-- 给自己召唤
		local token1 = Duel.CreateToken(tp,98941045)
		Duel.SpecialSummonStep(token1,0,tp,tp,false,false,POS_FACEUP)
		-- 给对方召唤
		local token2 = Duel.CreateToken(tp,98941045)
		Duel.SpecialSummonStep(token2,0,tp,1-tp,false,false,POS_FACEUP)
		
		Duel.SpecialSummonComplete()
	
	-- 效果●2：连接召唤
	elseif label == 2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g = Duel.SelectMatchingCard(tp,s.lkfilter,tp,LOCATION_EXTRA,0,1,1,nil)
		local tc = g:GetFirst()
		if tc then
			Duel.LinkSummon(tp,tc,nil)
		end

	-- 效果●3：回收并洗手牌墓地
	elseif label == 3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g = Duel.SelectMatchingCard(tp,s.tdfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,7,7,nil)
		if #g == 7 then
			Duel.HintSelection(g)
			
			-- 在卡片离开原本区域前，先检测它们是否全都是“卡名不同的0x10c怪兽”
			local is_diff_monsters = true
			local names = {}
			for tc in aux.Next(g) do
				if not (tc:IsType(TYPE_MONSTER) and tc:IsSetCard(0x10c)) then
					is_diff_monsters = false
				end
				local code = tc:GetCode()
				if names[code] then
					is_diff_monsters = false -- 存在重复卡名
				end
				names[code] = true
			end

			-- 执行洗回卡组
			if Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT) > 0 then
				-- 确认所有7张卡都已经成功回到卡组/额外卡组
				local og = Duel.GetOperatedGroup()
				local ct = og:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
				
				-- 如果满足“卡名全部不同且都是0x10c怪兽”的额外条件
				if ct == 7 and is_diff_monsters then
					-- 让对方的手卡·墓地的卡全部回到卡组
					local op_g = Duel.GetFieldGroup(tp,0,LOCATION_HAND+LOCATION_GRAVE)
					if #op_g > 0 then
						Duel.SendtoDeck(op_g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
					end
				end
			end
		end
	end
	if not e:IsActiveType(EFFECT_TYPE_ACTIVATE) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_END)
		e1:SetRange(LOCATION_SZONE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetOperation(s.autosendop)
		e:GetHandler():RegisterEffect(e1)
	end
end
-- 连锁结束时，自动送墓的函数
function s.autosendop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	-- 动用规则送墓，不视为被效果送墓或破坏
	Duel.SendtoGrave(c,REASON_RULE)
	e:Reset() -- 重置这个临时效果
end
function c98941044.actarget(e,te,tp)
	e:SetLabelObject(te)
	return te:GetHandler()==e:GetHandler()
end
function c98941044.costop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mask = s.get_valid_zones(tp)
	if mask == 0 then return false end 
	local zone_s = bit.lshift(mask,8) 
	local disable_mask = (~mask) & 0x1f
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOZONE)
	local dis=Duel.SelectField(tp,1,LOCATION_SZONE,0,bit.bnot(zone_s))
	local seq1 = 0
	for i=0,4 do
		if bit.band(bit.rshift(dis,8),bit.lshift(1,i))~=0 then 
			seq1 = i 
			break 
		end
	end
	local tc11 = Duel.GetFieldCard(tp, LOCATION_SZONE, seq1)
	if tc11 then
		if tc11:IsAbleToHand() and Duel.SelectOption(tp,aux.Stringid(11132674,3),aux.Stringid(11132674,4))==1 then
			Duel.SendtoHand(tc11,nil,REASON_RULE)
		 else
			 Duel.Destroy(tc11,REASON_RULE)
		end
	end
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,false,bit.rshift(dis,8))
	local te=e:GetLabelObject()
	e:GetHandler():CreateEffectRelation(te)
	local c=e:GetHandler()
	local ev0=Duel.GetCurrentChain()+1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetCountLimit(1)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return ev==ev0 end)
	e1:SetOperation(c98941044.rsop)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAIN_NEGATED)
	Duel.RegisterEffect(e2,tp)
end
function c98941044.rsop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if e:GetCode()==EVENT_CHAIN_SOLVED and rc:IsRelateToEffect(re) then
		rc:SetStatus(STATUS_EFFECT_ENABLED,true)
	end
	if e:GetCode()==EVENT_CHAIN_NEGATED and rc:IsRelateToEffect(re) then
		rc:SetStatus(STATUS_ACTIVATE_DISABLED,true)
	end
end

-- 获取当前连锁中，所有在场上发动过效果的卡 对应 tp 的主要怪兽区域掩码(Mask)
function s.get_valid_zones(tp)
	local zone=0
	for i=1,Duel.GetCurrentChain() do
		local loc,seq,cp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE,CHAININFO_TRIGGERING_CONTROLER)
		-- 只有在场上发动过效果的卡才纳入计算
		if bit.band(loc,LOCATION_ONFIELD)~=0 then
			local m_seq=-1
			-- 如果是在怪兽区发动的
			if loc==LOCATION_MZONE then
				if seq<=4 then
					m_seq = cp==tp and seq or (4-seq)
				elseif seq==5 then
					m_seq = cp==tp and 1 or 3
				elseif seq==6 then
					m_seq = cp==tp and 3 or 1
				end
			-- 如果是在魔陷区发动的（注意场地区域的seq通常是5，没有对应的常规魔陷纵列，因此不考虑）
			elseif loc==LOCATION_SZONE then
				if seq<=4 then
					m_seq = cp==tp and seq or (4-seq)
				end
			end
			-- 收集算出来的自己的魔法陷阱区0-4号格子
			if m_seq>=0 and m_seq<=4 then
				zone=bit.bor(zone,bit.lshift(1,m_seq))
			end
		end
	end
	return zone
end

function s.thcon(e, tp, eg, ep, ev, re, r, rp)
	-- 必须是自己发动的效果 (rp == tp)
	-- 必须是怪兽效果 (re:IsActiveType(TYPE_MONSTER))
	-- 必须是「字段0x10c」怪兽的效果 (re:GetHandler():IsSetCard(0x10c))
	-- 必须在场上发动 (触发时的位置属于 LOCATION_ONFIELD)
	local loc = Duel.GetChainInfo(ev, CHAININFO_TRIGGERING_LOCATION)
	return rp == tp 
		and re:IsActiveType(TYPE_MONSTER) 
		and re:GetHandler():IsSetCard(0x10c)
		and (loc & LOCATION_ONFIELD) ~= 0
end

-- 检索/回收过滤：卡组/墓地中非本名（此卡以外）的「字段0x10c」卡，或者「字段0xfe」魔陷
function s.thfilter(c, id)
	local is_10c = c:IsSetCard(0x10c)
	local is_fe_st = c:IsSetCard(0xfe) and c:IsType(TYPE_SPELL + TYPE_TRAP)
	return (is_10c or is_fe_st) and not c:IsCode(id) and c:IsAbleToHand()
end

function s.thtg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then 
		return Duel.IsExistingMatchingCard(s.thfilter, tp, LOCATION_DECK + LOCATION_GRAVE, 0, 1, nil, id) 
	end
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK + LOCATION_GRAVE)
end

function s.thop(e, tp, eg, ep, ev, re, r, rp)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
	-- aux.NecroValleyFilter 用于在涉及墓地时兼容「王家之谷」
	local g = Duel.SelectMatchingCard(tp, aux.NecroValleyFilter(s.thfilter), tp, LOCATION_DECK + LOCATION_GRAVE, 0, 1, 1, nil, id)
	if #g > 0 then
		Duel.SendtoHand(g, nil, REASON_EFFECT)
		Duel.ConfirmCards(1 - tp, g)
	end
end