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
	return c:IsAbleToDeckAsCost() and c:IsType(TYPE_MONSTER) 
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,c)
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
		and Duel.IsExistingMatchingCard(s.tffilter,tp,LOCATION_DECK,0,1,nil) end
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	
	-- 放置怪兽到魔陷区
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc=Duel.SelectMatchingCard(tp,s.tffilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
		if tc and Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
			-- 当作永续陷阱卡使用
			local e1=Effect.CreateEffect(c)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
			tc:RegisterEffect(e1)
			
			-- 挂载：相同纵列有卡被放置时加入手卡
			local e2=Effect.CreateEffect(c)
			e2:SetDescription(aux.Stringid(id,1)) -- "加入手卡"
			e2:SetCategory(CATEGORY_TOHAND)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
			e2:SetProperty(EFFECT_FLAG_DELAY)
			e2:SetCode(EVENT_MOVE)
			e2:SetRange(LOCATION_SZONE)
			e2:SetCondition(s.mvcon)
			e2:SetTarget(s.mvtg)
			e2:SetOperation(s.mvop)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
		end
	end
	
	-- 这个回合只有1次，对方从卡组把卡加入手卡时，可以把被破坏的1张自己的卡加入手卡
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_TO_HAND)
	e3:SetCondition(s.reccon)
	e3:SetOperation(s.recop_defer)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
	
	-- 那之后，判定除外回手
	if Duel.GetFlagEffect(tp,id)<=1 and c:IsRelateToEffect(e) then
		if Duel.SelectYesNo(tp,aux.Stringid(id,4)) then -- "是否将这张卡除外？"
			Duel.BreakEffect()
        if Duel.Remove(c,POS_FACEUP,REASON_EFFECT)>0 and c:IsLocation(LOCATION_REMOVED) then
				-- 打上除外标记
				c:RegisterFlagEffect(id+1,RESET_EVENT+RESETS_STANDARD,0,1)
				c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,3))
				
				-- 记录除外时的当前阶段
				local current_phase = Duel.GetCurrentPhase()
					if current_phase >= PHASE_BATTLE_START and current_phase <= PHASE_BATTLE then 
					current_phase = PHASE_BATTLE  end
				
				-- 注册一个全局状态监听器
				local e_ret = Effect.CreateEffect(c)
				e_ret:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e_ret:SetCode(EVENT_ADJUST) -- 状态调整，最快捕捉到阶段变化的事件
				e_ret:SetLabel(current_phase)
				e_ret:SetLabelObject(c)
				e_ret:SetCondition(s.rthcon)
				e_ret:SetOperation(s.rthop)
				Duel.RegisterEffect(e_ret,tp)
			end
		end
	end
end

-- EVENT_MOVE 相关逻辑
function s.mvfilter(c,col)
	return aux.GetColumn(c)==col
end
function s.mvcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local col=aux.GetColumn(c)
	return col and eg:IsExists(s.mvfilter,1,c,col)
end
function s.mvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function s.mvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end

-- 对方加入手卡时回收自己破坏卡的逻辑
function s.shfilter(c,tp)
	return c:IsControler(1-tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function s.reccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.shfilter,1,nil,tp) and Duel.GetFlagEffect(tp,id+3)==0
end
function s.recfilter(c)
	return c:IsReason(REASON_DESTROY) and c:IsAbleToHand()
end
function s.recop_defer(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()==0 then
		s.do_rec_action(tp)
	else
		local chain_id = Duel.GetCurrentChain()
		if Duel.GetFlagEffectLabel(tp,id+4) ~= chain_id then
			Duel.RegisterFlagEffect(tp,id+4,RESET_CHAIN,0,1,chain_id)
			local e1=Effect.CreateEffect(e:GetOwner())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_CHAIN_SOLVED)
			e1:SetLabel(chain_id)
			e1:SetOperation(s.recop_execute)
			e1:SetReset(RESET_CHAIN)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function s.recop_execute(e,tp,eg,ep,ev,re,r,rp)
	if ev == e:GetLabel() then
		s.do_rec_action(tp)
		e:Reset()
	end
end
function s.do_rec_action(tp)
	if Duel.GetFlagEffect(tp,id+3)>0 then return end
	if Duel.IsExistingMatchingCard(s.recfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) then
		if Duel.SelectYesNo(tp,aux.Stringid(id,2)) then --"是否回收被破坏的卡？"
			Duel.RegisterFlagEffect(tp,id+3,RESET_PHASE+PHASE_END,0,1)
			Duel.Hint(HINT_CARD,0,id)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.recfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
			if #g>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end
	end
end

-- 延迟回手的相关逻辑
function s.rthcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	-- 严谨防Bug：如果这张卡被别的卡移出了除外区，或者回过卡组等，标记会消失
	-- 此时说明不再需要回手，直接清理掉这个监听器，避免内存残留
	if c:GetFlagEffect(id+1)==0 then
		e:Reset()
		return false
	end
	
	-- 当“现在的阶段”不再等于“记录的阶段”时，说明下个阶段开始了！
	return Duel.GetCurrentPhase() ~= e:GetLabel() and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end

-- 回手操作
function s.rthop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	
	Duel.Hint(HINT_CARD,0,id) -- 闪烁一下卡片，告诉玩家是它自己回来的
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