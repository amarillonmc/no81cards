--落日残响祭典启幕
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
	
	--①：手卡放置（二速 + 同连锁限1）
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
	e1:SetCountLimit(1,0,EFFECT_COUNT_CODE_CHAIN) -- 同连锁最多1次
	c:RegisterEffect(e1)

	--②：卡的发动（解放卡组+检索+自毁）
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetCategory(CATEGORY_RELEASE+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,id)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetTarget(s.acttg)
	e2:SetOperation(s.actop)
	c:RegisterEffect(e2)

	--③：重置陷阱（二速）
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,3))
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1,id+1)
	e3:SetTarget(s.settg)
	e3:SetOperation(s.setop)
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
	-- 自己回合
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

-- === 效果②：发动效果（卡组解放+检索+自毁） ===
function s.relfilter(c)
	return c:IsSetCard(0x614) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end

function s.pubfilter(c)
	return c:IsSetCard(0x614) and c:IsType(TYPE_MONSTER) and c:IsPublic()
end

function s.thfilter(c)
	return c:IsSetCard(0x614) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end

function s.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.relfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,tp,LOCATION_DECK)
end

function s.actop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	-- 1. 从卡组选1只「落日残响」怪兽解放
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,s.relfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		-- 模拟解放：送去墓地并带有 REASON_RELEASE
		if Duel.SendtoGrave(g,REASON_EFFECT+REASON_RELEASE)>0 then
			-- 2. 检查手卡是否有公开的「落日残响」怪兽
			local pub_g=Duel.GetMatchingGroup(s.pubfilter,tp,LOCATION_HAND,0,nil)
			if #pub_g==0 and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_GRAVE,0,1,nil) 
				and Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sg=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
			end
		end
	end
	
	-- 3. 那之后，场上的这张卡解放
	if c:IsRelateToEffect(e) and c:IsOnField() then
		Duel.BreakEffect()
		Duel.Release(c,REASON_EFFECT)
	end
end

-- === 效果③：重置（二速） ===
function s.setfilter(c)
	return c:IsSetCard(0x614) and c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) 
		and c:IsFaceup() and c:IsCanTurnSet()
end

function s.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and s.setfilter(chkc) and chkc~=c end
	if chk==0 then return c:IsCanTurnSet() 
		and Duel.IsExistingTarget(s.setfilter,tp,LOCATION_SZONE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,s.setfilter,tp,LOCATION_SZONE,0,1,1,c)
	g:AddCard(c)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,2,0,0)
end

function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local g=Group.CreateGroup()
	if c:IsRelateToEffect(e) then g:AddCard(c) end
	if tc:IsRelateToEffect(e) then g:AddCard(tc) end
	if #g>0 then
		Duel.ChangePosition(g,POS_FACEDOWN)
		Duel.RaiseEvent(g,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
end