--落日残响·群愿
local s,id,o=GetID()
function s.initial_effect(c)
	--①：公开手卡发动
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_POSITION+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.con1)
	e1:SetCost(s.cost1)
	e1:SetTarget(s.tg1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)
	local e1b=e1:Clone()
	e1b:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e1b)
	local e1c=e1:Clone()
	e1c:SetCode(EVENT_RELEASE)
	e1c:SetCondition(s.con1_rel)
	c:RegisterEffect(e1c)

	--②：被解放
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,4))
	e2:SetCategory(CATEGORY_RELEASE) -- 从卡组解放通常视为送去墓地
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_RELEASE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.con2)
	e2:SetTarget(s.tg2)
	e2:SetOperation(s.op2)
	c:RegisterEffect(e2)
end

-- === 效果①：手卡触发 ===
function s.cfilter(c,tp)
	return c:IsSummonPlayer(tp)
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end
function s.con1_rel(e,tp,eg,ep,ev,re,r,rp)
	return #eg>0
end

function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsPublic() end
	Duel.ConfirmCards(1-tp,c)
	-- 直到回合结束时公开
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,4))
end

function s.tf2(c)
	return c:IsSetCard(0x614) and c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) 
		and c:IsFaceup() and c:IsCanTurnSet()
end
function s.tf3(c)
	return c:IsSetCard(0x614) and c:IsType(TYPE_TRAP) and (c:IsAbleToHand() or c:IsSSetable())
end

function s.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and s.tf2(chkc) end
	
	local b1=true -- 总是可以选择回复LP
	local b2=Duel.IsExistingTarget(s.tf2,tp,LOCATION_SZONE,0,1,nil)
	-- 选项3有1回合1次的限制
	local b3=(Duel.GetFlagEffect(tp,id)==0) 
		and Duel.IsExistingMatchingCard(s.tf3,tp,LOCATION_DECK,0,1,nil)

	if chk==0 then return b1 or b2 or b3 end

	local ops={}
	local opval={}
	local off=1
	
	-- 选项1：回复100
	ops[off]=aux.Stringid(id,1)
	opval[off]=1
	off=off+1
	
	-- 选项2：盖放表侧陷阱
	if b2 then
		ops[off]=aux.Stringid(id,2)
		opval[off]=2
		off=off+1
	end
	
	-- 选项3：检索或盖放卡组陷阱
	if b3 then
		ops[off]=aux.Stringid(id,3)
		opval[off]=3
		off=off+1
	end

	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op+1]
	e:SetLabel(sel)

	if sel==1 then
		Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,100)
	elseif sel==2 then
		Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,0,0)
	elseif sel==3 then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_DECK)
		-- 记录选项3已使用
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
	end
end

function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	if sel==1 then
		Duel.Recover(tp,100,REASON_EFFECT)
	elseif sel==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
		local tc=Duel.SelectTarget(tp,s.tf2,tp,LOCATION_SZONE,0,1,1,nil):GetFirst()
		if tc:IsFaceup() then
			Duel.ChangePosition(tc,POS_FACEDOWN)
			Duel.RaiseEvent(tc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		end
	elseif sel==3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local g=Duel.SelectMatchingCard(tp,s.tf3,tp,LOCATION_DECK,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			local b_th=tc:IsAbleToHand()
			local b_set=tc:IsSSetable()
			local op=0
			if b_th and b_set then
				op=Duel.SelectOption(tp,1190,1153) -- 加入手卡 / 盖放
			elseif b_th then
				op=0
			else
				op=1
			end
			
			if op==0 then
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tc)
			else
				Duel.SSet(tp,tc)
			end
		end
	end
end

-- === 效果②：被解放触发 ===
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	-- 手卡或场上被解放
	return c:IsReason(REASON_RELEASE) and c:IsPreviousLocation(LOCATION_HAND+LOCATION_ONFIELD)
end

function s.tf2_deck(c)
	return c:IsSetCard(0x614) and c:IsType(TYPE_TRAP) and c:IsAbleToGrave()
end

function s.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tf2_deck,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,tp,LOCATION_DECK)
end

function s.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,s.tf2_deck,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		-- 从卡组解放（模拟：送墓 + 解放原因）
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_RELEASE)
	end
end