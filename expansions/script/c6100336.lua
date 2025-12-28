--落日残响夏夜永恒
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
	
	--②：发动效果 (解放手卡 -> 检索 -> 自毁)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetCategory(CATEGORY_RELEASE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(s.acttg)
	e2:SetOperation(s.actop)
	c:RegisterEffect(e2)
	
	--③：被其他卡解放 -> 盖放自身 & 除外墓地
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,3))
	e3:SetCategory(CATEGORY_POSITION+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_RELEASE)
	e3:SetCountLimit(1,id)
	e3:SetCondition(s.spcon)
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
function s.relfilter(c,tp)
	-- 公开的手卡 & 本家怪兽 & 可被效果解放
	return c:IsSetCard(0x614) and c:IsType(TYPE_MONSTER) and c:IsPublic() and c:IsReleasableByEffect()
		and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end

function s.thfilter(c,code)
	-- 同字段 & 不同名 & 可检索
	return c:IsSetCard(0x614) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsCode(code)
end

function s.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.relfilter,tp,LOCATION_HAND,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function s.actop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	-- 1. 选解放的怪兽
	local g=Duel.SelectMatchingCard(tp,s.relfilter,tp,LOCATION_HAND,0,1,1,nil,tp)
	if #g>0 then
		local rc=g:GetFirst()
		local code=rc:GetCode()
		-- 2. 执行解放
		if Duel.Release(rc,REASON_EFFECT)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			-- 3. 检索不同名怪兽
			local sg=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil,code)
			if #sg>0 then
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
			end
		end
	end
	
	-- 4. 自毁
	if c:IsRelateToEffect(e) and c:IsOnField() then
		Duel.BreakEffect()
		Duel.Release(c,REASON_EFFECT)
	end
end

-- === 效果③：被其他卡解放 ===
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	-- EVENT_RELEASE 触发时，c 已在目的地 (墓地/除外区)，IsReason(REASON_EFFECT) 可直接判断是否为效果导致
	-- 检查 re 是否存在且不是自身
	return c:IsReason(REASON_EFFECT) and re and re:GetHandler()~=c
end

function s.rmfilter(c)
	return c:IsSetCard(0x614) and c:IsType(TYPE_TRAP) and c:IsAbleToRemove()
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.rmfilter(chkc) and chkc~=c end
	if chk==0 then return c:IsSSetable() 
		and Duel.IsExistingTarget(s.rmfilter,tp,LOCATION_GRAVE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,s.rmfilter,tp,LOCATION_GRAVE,0,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,c,1,0,0)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsSSetable() then
		if Duel.SSet(tp,c)>0 then
			if tc and tc:IsRelateToEffect(e) then
				Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
			end
		end
	end
end