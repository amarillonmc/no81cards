--织梦的裁断
local s,id,o=GetID()
function s.initial_effect(c)
	--发动与处理
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)

	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end

-- === 全局监听 ===
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if re:IsActiveType(TYPE_MONSTER) and re:GetActivateLocation()==LOCATION_MZONE then
		rc:RegisterFlagEffect(id+1,RESET_EVENT+RESETS_STANDARD,0,1)
	end
end

-- === Cost：展示手卡和额外卡组 ===
function s.cfilter1(c)
	return c:IsSetCard(0x613) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function s.cfilter2(c,tp)
	if not (c:IsSetCard(0x613) and c:IsType(TYPE_SYNCHRO+TYPE_LINK)) then return false end
	-- 如果是连接怪兽，对方场上必须有表侧表示怪兽供后续处理
	if c:IsType(TYPE_LINK) then
		return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil)
	end
	return true
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter1,tp,LOCATION_HAND,0,1,nil)
		and Duel.IsExistingMatchingCard(s.cfilter2,tp,LOCATION_EXTRA,0,1,nil,tp) end
		
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g1=Duel.SelectMatchingCard(tp,s.cfilter1,tp,LOCATION_HAND,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g2=Duel.SelectMatchingCard(tp,s.cfilter2,tp,LOCATION_EXTRA,0,1,1,nil,tp)
	
	-- 合并展示
	g1:Merge(g2)
	Duel.ConfirmCards(1-tp,g1)
	Duel.ShuffleHand(tp)
	
	-- 判定展示的额外卡组种类
	local is_synchro = g2:GetFirst():IsType(TYPE_SYNCHRO)
	local is_link = g2:GetFirst():IsType(TYPE_LINK)
	
	local label = 0
	if is_synchro then label = label + 1 end
	if is_link then label = label + 2 end
	e:SetLabel(label)
	
	-- 判定是否包含恶魔族或天使族
	if g1:IsExists(Card.IsRace,1,nil,RACE_FIEND+RACE_FAIRY) then
		local c=e:GetHandler()
		-- 赋予不可无效化抗性
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_INACTIVATE)
		e1:SetValue(s.effectfilter)
		e1:SetLabelObject(e)
		e1:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_DISEFFECT)
		Duel.RegisterEffect(e2,tp)
		-- 让客户端显示该卡受到保护
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,1))
	end
end

-- 确保只有这张卡的这次发动的连锁不能被无效
function s.effectfilter(e,ct)
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	return te==e:GetLabelObject()
end

-- === Target：预告效果分类 ===
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter1,tp,LOCATION_HAND,0,1,nil)
		and Duel.IsExistingMatchingCard(s.cfilter2,tp,LOCATION_EXTRA,0,1,nil,tp) end
	-- 由于 Target chk==1 是在 Cost 后执行的，这里可以读取到 Cost 设置的 Label
	local label = e:GetLabel()
	if (label & 2) ~= 0 then
		e:SetCategory(CATEGORY_DISABLE)
	else
		e:SetCategory(0)
	end
end

-- === Operation：分歧处理 ===
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local label = e:GetLabel()
	local c=e:GetHandler()
	
	-- ● 同调：赋予全场「朦雨」魔陷抗性
	if (label & 1) ~= 0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x613))
		e1:SetValue(s.immfilter)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
	
	-- ● 连接：无效未处于连接状态的怪兽
	if (label & 2) ~= 0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.HintSelection(g)
			-- 如果不在连接状态则无效化
			if not tc:IsLinkState() then
				Duel.NegateRelatedChain(tc,RESET_TURN_SET)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetValue(RESET_TURN_SET)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e2)
			end
		end
	end
end

-- === 免疫过滤 ===
function s.immfilter(e,re)
	local tp=e:GetHandlerPlayer()
	-- 必须是对方效果
	if e:GetHandlerPlayer()==re:GetOwnerPlayer() or (e:GetHandlerPlayer()~=re:GetOwnerPlayer() and not re:IsActivated()) then return false end
	
	if re:IsActiveType(TYPE_SPELL+TYPE_TRAP) then
		if (re:GetActivateLocation() & LOCATION_ONFIELD) == 0 then return false end
		if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsStatus(STATUS_ACT_FROM_HAND) then return false end
		return true
	end
	
	if re:IsActiveType(TYPE_MONSTER) then
		local rc=re:GetHandler()
		if rc:GetFlagEffect(id+1)>=2 then return true end
	end
	
	return false
end