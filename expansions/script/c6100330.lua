--落日残响绮丽之宵
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
	
	--②：发动效果 (卡组解放 + 可选回收 + 自毁)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetCategory(CATEGORY_RELEASE+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.acttg)
	e2:SetOperation(s.actop)
	c:RegisterEffect(e2)
	
	--③：场上盖放 & 墓地放置 (二速)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,3))
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,id+1)
	e3:SetTarget(s.settg)
	e3:SetOperation(s.setop)
	c:RegisterEffect(e3)
	
	--全局检查：监听盖放事件
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
function s.relfilter(c)
	return c:IsSetCard(0x614) and c:IsType(TYPE_TRAP) and c:IsAbleToGrave()
end

function s.other_faceup_trap_filter(c)
	return c:IsSetCard(0x614) and c:IsType(TYPE_TRAP) and c:IsFaceup()
end

function s.thfilter(c)
	return c:IsSetCard(0x614) and c:IsType(TYPE_TRAP) and c:IsAbleToHand()
end

function s.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.relfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,tp,LOCATION_DECK)
end

function s.actop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	-- 1. 从卡组选1张「落日残响」陷阱卡解放
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,s.relfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		if Duel.SendtoGrave(g,REASON_EFFECT+REASON_RELEASE)>0 then
			-- 2. 检查魔陷区是否有其他表侧本家陷阱 (排除自身)
			local g_check=Duel.GetMatchingGroup(s.other_faceup_trap_filter,tp,LOCATION_SZONE,0,c)
			if #g_check==0 and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_GRAVE,0,1,nil) 
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

-- === 效果③：场上 -> 盖放 & 墓地 -> 放置 ===
function s.setfilter(c)
	return c:IsSetCard(0x614) and c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) and not c:IsForbidden()
end

function s.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.setfilter(chkc) end
	if chk==0 then return e:GetHandler():IsCanTurnSet()
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(s.setfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.setfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,e:GetHandler(),1,0,0)
end

function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	
	-- 这张卡盖放
	if c:IsRelateToEffect(e) and c:IsCanTurnSet() then
		if Duel.ChangePosition(c,POS_FACEDOWN)>0 then
			Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
			
			-- 作为对象的卡在自己的魔法与陷阱区域表侧表示放置
			if tc and tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
				Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			end
		end
	end
end