--星遗物所开拓的虚界
local s,id=GetID()
function s.initial_effect(c)
	--①：作为这张卡发动时的效果的处理（可选）
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)

	--②：对方手卡怪兽效果无效化
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(s.negcon)
	e2:SetOperation(s.negop)
	c:RegisterEffect(e2)
end

-- 辅助函数：获取卡片在场上的绝对纵列编号 (0~4)
function s.get_column(c)
	local seq = c:GetSequence()
	if seq < 5 then
		return c:IsControler(0) and seq or (4 - seq)
	else
		-- 额外怪兽区域 (EMZ)
		if c:IsControler(0) then
			return seq == 5 and 1 or 3
		else
			return seq == 5 and 3 or 1
		end
	end
end

-- ① 效果过滤条件：自己场上的「机界骑士」怪兽
function s.tgfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x10c)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.tgfilter(chkc) end
	-- 永续陷阱卡自身发动在任何时候都是合法的
	if chk == 0 then return true end
	
	-- 询问玩家是否在发动卡片的同时，选择一只「机界骑士」怪兽处理效果
	local g=Duel.GetMatchingGroup(s.tgfilter,tp,LOCATION_MZONE,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		Duel.SelectTarget(tp,s.tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
		e:SetLabel(1) -- 标记为：玩家选择了处理效果
	else
		e:SetLabel(0) -- 标记为：不处理效果，仅单纯贴场
	end
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	-- 如果玩家选择不处理效果，直接结束
	if e:GetLabel() == 0 then return end
	
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		-- 赋予这个回合只有1次不会被战斗·效果破坏的抗性
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(id,3))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTIBLE_COUNT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetCountLimit(1)
		e1:SetValue(s.valcon)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		
		-- 那之后，可以移动该怪兽（必须存在未使用的其他主要怪兽区域）
		-- 检测自己场上当前可用的主要怪兽区域（排除被卡片效果封锁或已有怪兽的区域）
		local free_zones = 0
		for i=0,4 do
			if Duel.CheckLocation(tp,LOCATION_MZONE,i) then
				free_zones = free_zones | (1 << i)
			end
		end
		
		if free_zones > 0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		   local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
		   local nseq=math.log(s,2)
		   Duel.MoveSequence(tc,nseq)
		end
	end
end

-- 破坏抗性过滤（战斗 或 效果破坏）
function s.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end

-- ② 效果判断：检测是否有“同纵列对方魔陷区没有卡存在的「机界骑士」连接怪兽”
function s.condfilter(c,tp)
	if not (c:IsFaceup() and c:IsSetCard(0x10c) and c:IsType(TYPE_LINK)) then return false end
	local col=s.get_column(c)
	local op_seq= (1-tp == 0) and col or (4 - col)
	local op_card=Duel.GetFieldCard(1-tp,LOCATION_SZONE,op_seq)
	return not op_card -- 对方相同纵列的魔陷区域没有卡存在
end

function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	-- 必须是对方发动的效果
	if rp ~= 1-tp then return false end
	-- 必须是手卡发动的效果
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if bit.band(loc,LOCATION_HAND) == 0 then return false end
	-- 必须是怪兽的效果
	if not re:IsActiveType(TYPE_MONSTER) then return false end
	-- 必须满足己方有上述机界骑士连接怪兽
	return Duel.IsExistingMatchingCard(s.condfilter,tp,LOCATION_MZONE,0,1,nil,tp)
end

function s.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
