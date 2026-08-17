--璇序锋峦“罅影”风迹
local s,id,o=GetID()
function s.initial_effect(c)
	--全局监听：记录同名卡的发动
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end

	--①：放置怪兽为陷阱，附加全局回收，除外回手
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DRAW_PHASE+TIMING_STANDBY_PHASE,TIMING_DRAW_PHASE+TIMING_STANDBY_PHASE+TIMINGS_CHECK_MONSTER)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)

	--②：主要阶段回收自身
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,3))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(s.thcost)
	e2:SetTarget(s.thtg2)
	e2:SetOperation(s.thop2)
	c:RegisterEffect(e2)
end

-- === 全局监听 ===
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsCode(id) and re:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.RegisterFlagEffect(rp,id,RESET_PHASE+PHASE_END,0,1)
	end
end

-- === 效果①：放置与光环 ===
function s.tdfilter(c)
	return c:IsAbleToDeckAsCost()
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.tdfilter,tp,LOCATION_REMOVED,0,c)
	-- 询问是否让1张卡回到卡组最上面来发动
	if #g>=3 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:Select(tp,3,3,nil)
		Duel.SendtoDeck(sg,nil,SEQ_DECKTOP,REASON_COST)
			if #sg>0 then
		Duel.SortDecktop(tp,tp,#sg)
		for i=1,#sg do
			local mg=Duel.GetDecktopGroup(tp,1)
			Duel.MoveSequence(mg:GetFirst(),SEQ_DECKBOTTOM)
		end
	end
	else
		e:SetLabel(0)
	end
end

function s.tffilter(c)
	return c:IsSetCard(0x3615) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(s.tffilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil) end
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	
	-- 放置怪兽到魔陷区
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc=Duel.SelectMatchingCard(tp,s.tffilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil):GetFirst()
		if tc and Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
			-- 当作永续陷阱卡使用
			local e1=Effect.CreateEffect(c)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
			tc:RegisterEffect(e1)
			
			local fid = tc:GetFieldID()
			local cg = tc:GetColumnGroup()
			for cc in aux.Next(cg) do
				-- 给已经存在的卡打上标记，Label设为这只怪兽的专属FieldID
				cc:RegisterFlagEffect(id+100, RESET_EVENT+RESETS_STANDARD, 0, 1, fid)
			end
			
			-- 【第一步】：连续效果雷达，时刻扫描同一列的新面孔
			local e2a=Effect.CreateEffect(c)
			e2a:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2a:SetCode(EVENT_ADJUST)
			e2a:SetRange(LOCATION_SZONE)
			e2a:SetOperation(s.mvadjust)
			e2a:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2a)
			
			-- 【第二步】：触发效果监听雷达信号，带 DELAY 标记安全入连锁
			local e2b=Effect.CreateEffect(c)
			e2b:SetDescription(aux.Stringid(id,1)) -- "加入手卡"
			e2b:SetCategory(CATEGORY_TOHAND)
			e2b:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F) -- 强制入连锁
			e2b:SetCode(EVENT_CUSTOM+id)
			e2b:SetProperty(EFFECT_FLAG_DELAY) -- 核心：通知系统将其放入延迟队列，避开屏蔽期
			e2b:SetTarget(s.mvtg)
			e2b:SetOperation(s.mvop)
			e2b:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2b)
		end
	end
	

	
	-- 那之后，判定除外回手
	if Duel.GetFlagEffect(tp,id)<=1 and c:IsRelateToEffect(e) then
		if Duel.SelectYesNo(tp,aux.Stringid(id,4)) then -- "是否将这张卡除外？"
			Duel.BreakEffect()
if Duel.Remove(c,POS_FACEUP,REASON_EFFECT)>0 and c:IsLocation(LOCATION_REMOVED) then
				-- 打上除外标记，防止离开除外区后误发
				c:RegisterFlagEffect(id+1,RESET_EVENT+RESETS_STANDARD,0,1)
				c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,4))
				-- 获取当前回合数和阶段，合成一个绝对时间戳 (乘以1000是为了留出足够的空间容纳阶段常数)
				-- 例如：第2回合的主要阶段1(常量为4) = 2004
				local current_mark = Duel.GetTurnCount() * 1000 + Duel.GetCurrentPhase()
				
				-- 注册状态监听器，在下个主要阶段开始时触发
				local e_ret = Effect.CreateEffect(c)
				e_ret:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e_ret:SetCode(EVENT_ADJUST) 
				e_ret:SetLabel(current_mark)
				e_ret:SetLabelObject(c)
				e_ret:SetCondition(s.rthcon)
				e_ret:SetOperation(s.rthop)
				Duel.RegisterEffect(e_ret,tp)
			end
		end
	end
end

-- EVENT_MOVE 相关逻辑
function s.mvadjust(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cg=c:GetColumnGroup()
	local fid=c:GetFieldID()
	local new_card = false
	
	-- 扫描同一列的所有卡
	for cc in aux.Next(cg) do
		local has_flag = false
		local labels = {cc:GetFlagEffectLabel(id+100)}
		-- 检查这张卡身上有没有当前雷达留下的“已扫描”标记
		for _, label in ipairs(labels) do
			if label == fid then
				has_flag = true
				break
			end
		end
		
		-- 如果没有标记，说明它是刚刚跑到这一列的“新面孔”！
		if not has_flag then
			-- 赶紧打上标记，防止重复报警
			cc:RegisterFlagEffect(id+100, RESET_EVENT+RESETS_STANDARD, 0, 1, fid)
			new_card = true
		end
	end
	
	-- 如果发现了新面孔，并且还没拉响过警报
	if new_card and c:GetFlagEffect(id+7)==0 then
		-- 锁死警报器（直到它被处理）
		c:RegisterFlagEffect(id+7, RESET_EVENT+RESETS_STANDARD, 0, 1)
		-- 拉响警报：向系统抛出自定义事件
		Duel.RaiseSingleEvent(c, EVENT_CUSTOM+id, e, 0, tp, tp, 0)
	end
end

-- 诱发效果接收到警报信号后，正式入连锁
function s.mvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	-- 解锁警报器，方便下次继续探测
	e:GetHandler():ResetFlagEffect(id+7)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end

function s.mvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end

-- 延迟回手的相关逻辑
function s.rthcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	-- 严谨防Bug：如果这张卡被别的卡移出了除外区，标记会消失，立刻销毁监听器
	if c:GetFlagEffect(id+1)==0 then
		e:Reset()
		return false
	end
	
	local ph = Duel.GetCurrentPhase()
	local is_main_phase = (ph == PHASE_MAIN1 or ph == PHASE_MAIN2)
	
	-- 生成现在的绝对时间戳
	local now_mark = Duel.GetTurnCount() * 1000 + ph
	
	-- 当且仅当目前处于主要阶段，且时间戳大于除外时记录的时间戳（即抵达了新的主要阶段）
	return is_main_phase and now_mark > e:GetLabel()
end

-- 回手操作
function s.rthop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	
	Duel.Hint(HINT_CARD,0,id) 
	Duel.SendtoHand(c,nil,REASON_EFFECT)
	
	c:ResetFlagEffect(id+1) -- 清除标记
	e:Reset() -- 任务完成，监听器自我销毁
end

-- === 效果②：除外墓地3张回收自身 ===
function s.gyfilter(c)
	return c:IsReason(REASON_DESTROY) and c:IsAbleToRemoveAsCost()
end

function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.gyfilter,tp,LOCATION_GRAVE,0,3,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.gyfilter,tp,LOCATION_GRAVE,0,3,3,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end

function s.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end

function s.thop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end