--璇序锋峦“层峦”守望
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

	--①：翻卡特召，赋予代破，除外回手
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)

	--②：主要阶段回收自身
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
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

-- === 效果①：翻卡与特召 ===
function s.tdfilter(c)
	return c:IsAbleToDeckAsCost() 
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.tdfilter,tp,LOCATION_GRAVE,0,c)
	-- 询问是否让1张卡回到卡组最上面来发动
	if #g>=3 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
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

function s.spfilter(c,e,tp)
	return c:IsSetCard(0x3615) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=6 end
	-- 此处是可选特召，所以不硬性要求 SetOperationInfo，不过可加上以明示可能发生的特召
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<6 then return end
	local c=e:GetHandler()
	
	-- 翻开卡组顶端6张卡
	Duel.ConfirmDecktop(tp,6)
	local g=Duel.GetDecktopGroup(tp,6)
	local sg=g:Filter(s.spfilter,nil,e,tp)
	
	-- 选择是否特召
	if #sg>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		-- 选那之内的1只「璇序锋峦」怪兽特殊召唤 (不取对象)
		local sc=sg:Select(tp,1,1,nil):GetFirst()
		if sc then
			Duel.DisableShuffleCheck()
			Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
			g:RemoveCard(sc)
		end
	end
	
	-- 剩下的卡用喜欢的顺序回到卡组最下面
	if #g>0 then
		Duel.SortDecktop(tp,tp,#g)
		for i=1,#g do
			local mg=Duel.GetDecktopGroup(tp,1)
			Duel.MoveSequence(mg:GetFirst(),SEQ_DECKBOTTOM)
		end
	end
	

	
	-- 那之后，判定除外回手
	-- 检查：这个回合没有其他同名卡发动过 (当前这个发动标记算作1次)
	if Duel.GetFlagEffect(tp,id)<=1 and c:IsRelateToEffect(e) then
		if Duel.SelectYesNo(tp,aux.Stringid(id,1)) then -- "是否将这张卡除外？"
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



-- 回手条件与操作
function s.rthcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
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