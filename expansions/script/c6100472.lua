--璇序锋峦“契迹”扶摇
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

	--①：破坏卡组顶，后续处理
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)

	--②：主要阶段回收自身
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,4))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(s.thcost)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end

-- === 全局监听 ===
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsCode(id) and re:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.RegisterFlagEffect(rp,id,RESET_PHASE+PHASE_END,0,1)
	end
end

-- === 效果①：Cost与发动 ===
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeckAsCost,tp,LOCATION_HAND+LOCATION_ONFIELD,0,c)
	-- 询问是否让1张卡回到卡组最上面来发动
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoDeck(sg,nil,SEQ_DECKTOP,REASON_COST)
		e:SetLabel(1) -- 标记使用了代替代价
	else
		e:SetLabel(0)
	end
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		-- 卡组必须至少有1张卡（或者通过Cost放回了1张）
		return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 
			or Duel.IsExistingMatchingCard(Card.IsAbleToDeckAsCost,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler()) 
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_DECK)
end

function s.plfilter(c)
	return c:IsSetCard(0x3615)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetDecktopGroup(tp,1)
	if #g==0 then return end
	
	local tc=g:GetFirst()
	-- 禁用洗牌检查，确保精准破坏卡组顶端
	Duel.DisableShuffleCheck()
	-- 提前确认卡片属性
	local is_xuanxu = tc:IsSetCard(0x3615)
	
	-- 破坏卡组最上面的卡
	if Duel.Destroy(tc,REASON_EFFECT)>0 and is_xuanxu then
		-- 是「璇序锋峦」卡的场合，再破坏3张
		local g3=Duel.GetDecktopGroup(tp,3)
		if #g3>0 then
			Duel.DisableShuffleCheck()
			Duel.BreakEffect()
			Duel.Destroy(g3,REASON_EFFECT)
		end
	end
	
	-- 如果是让卡回到卡组最上面发动的场合
	if e:GetLabel()==1 then
		local pg=Duel.GetMatchingGroup(s.plfilter,tp,LOCATION_DECK,0,nil)
		if #pg>0 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2)) -- "选择放置在卡组最上面的卡"
			local tc=pg:Select(tp,1,1,nil):GetFirst()
			Duel.BreakEffect()
		Duel.ShuffleDeck(tp)
		Duel.MoveSequence(tc,SEQ_DECKTOP)
		Duel.ConfirmDecktop(tp,1)
		end
	end
	
	-- 那之后，处理除外回手
	-- 检查：这个回合没有其他同名卡发动过 (因为这张卡发动了，所以当前标记==1)
	if Duel.GetFlagEffect(tp,id)<=1 and c:IsRelateToEffect(e) then
		if Duel.SelectYesNo(tp,aux.Stringid(id,3)) then -- "是否将这张卡除外？"
			Duel.BreakEffect()
if Duel.Remove(c,POS_FACEUP,REASON_EFFECT)>0 and c:IsLocation(LOCATION_REMOVED) then
				-- 打上除外标记
				c:RegisterFlagEffect(id+1,RESET_EVENT+RESETS_STANDARD,0,1)
				c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,4))
				
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
function s.rmfilter(c)
	-- 被破坏送去自己墓地
	return c:IsReason(REASON_DESTROY) and c:IsAbleToRemoveAsCost()
end

function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.rmfilter,tp,LOCATION_GRAVE,0,3,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.rmfilter,tp,LOCATION_GRAVE,0,3,3,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
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