--璇序锋峦“岚劫”烈
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

		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_REMOVE)
		ge2:SetOperation(s.rmcheckop)
		Duel.RegisterEffect(ge2,0)
	end

	--①：破坏同列，降攻，除外并回手
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_ATKCHANGE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DRAW_PHASE+TIMING_STANDBY_PHASE,TIMINGS_CHECK_MONSTER)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)

	--②：主要阶段回收自身
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id)
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

function s.rmcheckop(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	-- 如果当前是战斗阶段
	if ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE then
		-- 记录是哪个玩家导致了除外动作
		Duel.RegisterFlagEffect(rp,id+100,RESET_PHASE+PHASE_END,0,1)
	end
end

-- === 效果①：同列破坏与降攻 ===
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	-- 检查：这个回合的战斗阶段中，自己是否已经把卡除外过了 (作为誓约前提)
	local can_apply_oath = (Duel.GetFlagEffect(tp,id+100)==0)
	
	if chk==0 then return true end
	
	-- 询问是否适用代替自肃代价
	if can_apply_oath and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then -- 提示文本："是否让这个回合的战斗阶段中自己不能把卡除外来发动？"
		-- 挂载：自己不能把卡除外
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH+EFFECT_FLAG_CLIENT_HINT)
		e1:SetDescription(aux.Stringid(id,4)) -- 提示文本："战斗阶段不能把卡除外"
		e1:SetCode(EFFECT_CANNOT_REMOVE)
		e1:SetTargetRange(1,0)
		e1:SetCondition(s.rmcon)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		
		e:SetLabel(1) -- 给效果打上使用了代替代价的标记 (如果后续逻辑有需要的话)
	else
		e:SetLabel(0)
	end
end

function s.rmcon(e)
	local ph=Duel.GetCurrentPhase()
	-- 这个限制仅在战斗阶段期间生效
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end

function s.cfilter(c,tp)
	if not (c:IsSetCard(0x3615) and c:IsType(TYPE_MONSTER) and c:IsFaceup()) then return false end
	-- 必须该怪兽所在的纵列有对方的卡
	local col=c:GetColumnGroup()
	return col:IsExists(Card.IsControler,1,nil,1-tp)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	-- 要求场上必须有同列存在对方卡片的本家怪兽
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	-- 只能选同列有对方卡的「璇序锋峦」怪兽，最多2只
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_MZONE,0,1,2,nil,tp)
	if #g>0 then
		Duel.HintSelection(g)
		
		-- 收集对方在这些纵列的卡
		local dg=Group.CreateGroup()
		for tc in aux.Next(g) do
			local col=tc:GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
			dg:Merge(col)
		end
		
		-- 全部破坏
		if #dg>0 then
			Duel.Destroy(dg,REASON_EFFECT)
		end
		
		-- 这个回合中对方场上的怪兽的攻击力下降500
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetTargetRange(0,LOCATION_MZONE)
		e1:SetValue(-500)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
	
	-- 那之后，判定除外回手
	-- 检查：这个回合没有其他同名卡发动过 (当前这个发动标记算作1次)
	if Duel.GetFlagEffect(tp,id)<=1 and c:IsRelateToEffect(e) then
		if Duel.SelectYesNo(tp,aux.Stringid(id,1)) then -- "是否将这张卡除外？"
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

-- 回手条件与操作
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