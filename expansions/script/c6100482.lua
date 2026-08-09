--璇序锋峦“峥角”风符·守
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

	--发动后继续留在场上
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e0)

	--①：发动并放置指示物
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)

	--①：代破效果 (不入连锁)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(s.reptg)
	e2:SetValue(s.repval)
	e2:SetOperation(s.repop)
	c:RegisterEffect(e2)

	--①：有卡被破坏时，不入连锁除外怪兽 (连续效果 + 延迟处理机制)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(s.rmcon)
	e3:SetOperation(s.rmop_defer)
	c:RegisterEffect(e3)

	--②：被破坏回收
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(s.thcon)
	e4:SetTarget(s.thtg)
	e4:SetOperation(s.thop)
	c:RegisterEffect(e4)
end

function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsCode(id) then
		Duel.RegisterFlagEffect(rp,id,RESET_PHASE+PHASE_END,0,1)
	end
end

-- === 发动放置指示物 ===
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:AddCounter(0x161f,3)
	end
end

-- === 代破 ===
function s.repfilter(c,tp)
	return c:IsControler(tp) and c:IsOnField() and c:IsReason(REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end

function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetCounter(0x161f)>0 and eg:IsExists(s.repfilter,1,c,tp) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		return true
	else
		return false
	end
end

function s.repval(e,c)
	return s.repfilter(c,e:GetHandlerPlayer())
end

function s.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RemoveCounter(tp,0x161f,1,REASON_EFFECT+REASON_REPLACE)
	if c:GetCounter(0x161f)==0 then
		Duel.Destroy(c,REASON_EFFECT)
	end
end

-- === 不入连锁的除外处理 ===
function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	-- 排除这张卡自身被破坏的事件
	return not eg:IsContains(e:GetHandler())
end

-- 第一步：捕捉破坏事件，如果处于连锁中，则向该连锁阶级排入延迟监听
function s.rmop_defer(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetCounter(0x161f)==0 then return end
	
	-- 如果当前不在连锁处理中（例如战斗破坏），直接执行
	if Duel.GetCurrentChain()==0 then
		s.do_remove_action(c,tp)
	else
		-- 如果当前处于连锁中，且还没为这一个连锁排位注册过监听，则挂载延迟执行
		local chain_id = Duel.GetCurrentChain()
		if c:GetFlagEffectLabel(id+2) ~= chain_id then
			c:RegisterFlagEffect(id+2, RESET_EVENT+RESETS_STANDARD+RESET_CHAIN, 0, 1, chain_id)
			
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_CHAIN_SOLVED)
			e1:SetLabel(chain_id)
			e1:SetOperation(s.rmop_execute)
			e1:SetReset(RESET_CHAIN) -- 连锁结束自动销毁
			Duel.RegisterEffect(e1,tp)
		end
	end
end

-- 第二步：当那个破坏效果处理完毕（SOLVED）的瞬间，穿插执行不入连锁除外
function s.rmop_execute(e,tp,eg,ep,ev,re,r,rp)
	-- 确保是引发破坏的那个特定连锁阶级结算完毕
	if ev == e:GetLabel() then
		s.do_remove_action(e:GetHandler(), tp)
		e:Reset() -- 执行完自我销毁
	end
end

-- 第三步：实际的不入连锁执行逻辑
function s.do_remove_action(c, tp)
	if c:GetCounter(0x161f)==0 then return end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if #g==0 then return end
	
	-- 弹出提示询问是否拔毛除外
	if Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		c:RemoveCounter(tp,0x161f,1,REASON_EFFECT)
		local is_zero = (c:GetCounter(0x161f)==0)
		
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		if Duel.Remove(sg,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)>0 then
			local tc=Duel.GetOperatedGroup():GetFirst()
			-- 挂载：直到回合结束时回到场上
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetLabelObject(tc)
			e1:SetCountLimit(1)
			e1:SetOperation(s.retop)
			Duel.RegisterEffect(e1,tp)
		end
		
		-- 如果指示物归0，执行自身破坏
		if is_zero then
			Duel.Destroy(c,REASON_EFFECT)
		end
	end
end

function s.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end

-- === 效果②：回收 ===
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,id)==0
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end