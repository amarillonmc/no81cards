--落日残响薄暮静谧
local s,id,o=GetID()
function s.initial_effect(c)
	--盖放的回合也能发动
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e0:SetCondition(s.actcon)
	c:RegisterEffect(e0)
	
	--①：手卡放置 (二速 + 同连锁限1)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCondition(s.placecon)
	e1:SetCost(s.placecost)
	e1:SetTarget(s.placetg)
	e1:SetOperation(s.placeop)
	e1:SetCountLimit(1,0,EFFECT_COUNT_CODE_CHAIN)
	c:RegisterEffect(e1)
	
	--②：发动效果 (除外墓地陷阱 -> 解放或变永续陷阱 -> 自毁)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetCategory(CATEGORY_RELEASE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetTarget(s.target)
	e2:SetOperation(s.activate)
	c:RegisterEffect(e2)
	
	--③：被其他卡解放 -> 苏生
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,3))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_RELEASE)
	e3:SetCondition(s.spcon)
	e3:SetCost(s.spcost)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
	
	--全局检查
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SSET)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end

-- === 盖放检测逻辑 ===
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if not re or not re:GetHandler():IsSetCard(0x614) then return end
	local tc=eg:GetFirst()
	while tc do
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		tc=eg:GetNext()
	end
end

function s.actcon(e)
	return e:GetHandler():GetFlagEffect(id)>0
end

-- === 效果①：手卡放置 ===
function s.placecon(e,tp,eg,ep,ev,re,r,rp)
	-- 自己回合 & 魔陷区有空位
	return Duel.GetTurnPlayer()==tp and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end

function s.placecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
	Duel.ConfirmCards(1-tp,e:GetHandler())
end

function s.placetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end

function s.placeop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end

-- === 效果②：发动效果 ===
function s.cfilter(c)
	return c:IsSetCard(0x614) and c:IsType(TYPE_TRAP) and c:IsAbleToRemoveAsCost()
end

function s.tgfilter(c,tp)
	-- 对手场上表侧怪兽
	-- 如果要选“放置到魔陷区”，怪兽不能是Token，且对方魔陷区要有格子
	-- 但只要满足“解放”或“放置”其中之一即可为对象
	return c:IsFaceup()
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and s.tgfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.tgfilter,tp,0,LOCATION_MZONE,1,nil,tp) end -- 允许空发（仅变成表侧）
	
	local c=e:GetHandler()
	-- 检查是否有Cost和对象
	local b_eff = Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingTarget(s.tgfilter,tp,0,LOCATION_MZONE,1,nil,tp)
	
		-- 支付Cost
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
		
		-- 选择对象
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local tg=Duel.SelectTarget(tp,s.tgfilter,tp,0,LOCATION_MZONE,1,1,nil,tp)
		
		Duel.SetOperationInfo(0,CATEGORY_RELEASE,tg,1,0,0) -- 包含解放的可能性
		e:SetLabel(1) -- 标记使用了效果
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 then return end -- 没有使用效果，仅翻面
	
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local b1=true -- 解放总是可选
		local b2=not tc:IsType(TYPE_TOKEN) and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0
		
		local op=0
		if b1 and b2 then
			op=Duel.SelectOption(tp,aux.Stringid(id,4),aux.Stringid(id,5)) -- 解放, 变陷阱
		elseif b1 then
			op=0
		else
			return -- 理论上不会发生，因为Target Filter保证了至少能选
		end
		
		if op==0 then
			-- 解放
			Duel.Release(tc,REASON_EFFECT)
		else
			-- 放置到对方魔陷区
			if Duel.MoveToField(tc,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true) then
				local e1=Effect.CreateEffect(c)
				e1:SetCode(EFFECT_CHANGE_TYPE)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
				e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
				tc:RegisterEffect(e1)
			end
		end
		
		-- 那之后，场上的这张卡解放
		if c:IsRelateToEffect(e) and c:IsOnField() then
			Duel.BreakEffect()
			Duel.Release(c,REASON_EFFECT)
		end
	end
end

-- === 效果③：被其他卡解放 ===
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	-- EVENT_RELEASE 触发时，c 已在目的地 (墓地/除外区)，IsReason(REASON_EFFECT) 可直接判断是否为效果导致
	-- 检查 re 是否存在且不是自身
	return c:IsReason(REASON_EFFECT) and re and re:GetHandler()~=c
end

function s.spfilter(c,e,tp)
	return c:IsSetCard(0x614) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end