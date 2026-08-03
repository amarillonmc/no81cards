--破坏的美学
local s,id,o=GetID()
function s.initial_effect(c)
	
	--①：逐一处理后，无效连锁上对方所有的效果并破坏
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	
	--②：除外包含自身的3张卡，墓地/除外捞卡
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2)) -- "加入手卡"
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(s.thcost)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end

-- 获取这个连锁上属于对方的发动次数
function s.get_opp_chain_count(tp, ev)
	local count = 0
	for i=1, ev do
		if Duel.GetChainInfo(i, CHAININFO_TRIGGERING_PLAYER) == 1-tp then
			count = count + 1
		end
	end
	return count
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return s.get_opp_chain_count(tp, ev) > 0
end

-- 效果处理专用的过滤 (除外不计作Cost)
function s.rmfilter_eff(c)
	return c:IsReason(REASON_DESTROY) and c:IsAbleToRemove()
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local count = s.get_opp_chain_count(tp, ev)
	if chk==0 then 
		if count == 0 then return false end
		-- 收集当前的资源量
		local H = Duel.GetMatchingGroupCount(Card.IsDestructable, tp, LOCATION_HAND+LOCATION_ONFIELD, 0, e:GetHandler())
		local G = Duel.GetMatchingGroupCount(s.rmfilter_eff, tp, LOCATION_GRAVE, 0, nil)
		local possible = false
		
		-- 模拟数学预判：是否存在一种破坏与除外的组合(x 为破坏的次数)，使得即使不产生新的可以除外的卡，资源依旧足够支付
		for x = 0, math.min(count, H) do
			if 2 * (count - x) <= G + x then
				possible = true
				break
			end
		end
		return possible
	end
	-- 这张卡不强制指明破坏对象，因为其选择具有不确定性
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local count = s.get_opp_chain_count(tp, ev)
	if count == 0 then return end

	local success = true
	-- 进行等于对方发动次数的循环
	for i=1, count do
		local b1 = Duel.IsExistingMatchingCard(Card.IsDestructable, tp, LOCATION_HAND+LOCATION_ONFIELD, 0, 1, e:GetHandler())
		local b2 = Duel.IsExistingMatchingCard(s.rmfilter_eff, tp, LOCATION_GRAVE, 0, 2, nil)
		
		-- 【死局防护系统】确保你当前的选项不会导致后几次的循环被卡死
		local H = Duel.GetMatchingGroupCount(Card.IsDestructable, tp, LOCATION_HAND+LOCATION_ONFIELD, 0, e:GetHandler())
		local G = Duel.GetMatchingGroupCount(s.rmfilter_eff, tp, LOCATION_GRAVE, 0, nil)
		local left = count - i + 1 -- 剩余还需执行的次数
		
		local safe1 = false
		if b1 then
			-- 假定进行破坏后，H 减 1，G 加 1
			for x = 0, math.min(left-1, H-1) do
				if 2*(left-1 - x) <= G + 1 + x then safe1 = true break end
			end
			b1 = safe1
		end
		
		local safe2 = false
		if b2 then
			-- 假定进行除外后，H 不变，G 减 2
			for x = 0, math.min(left-1, H) do
				if 2*(left-1 - x) <= G - 2 + x then safe2 = true break end
			end
			b2 = safe2
		end

		local op = 0
		if b1 and b2 then
			op = Duel.SelectOption(tp, aux.Stringid(id,0), aux.Stringid(id,1))
		elseif b1 then
			op = Duel.SelectOption(tp, aux.Stringid(id,0))
		elseif b2 then
			op = Duel.SelectOption(tp, aux.Stringid(id,1)) + 1
		else
			-- 如果因为某些意外（比如怪兽有代破）导致循环崩溃卡死，强制中断处理并作废后续的无效化
			success = false
			break
		end

		if op == 0 then
			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DESTROY)
			local g = Duel.SelectMatchingCard(tp, Card.IsDestructable, tp, LOCATION_HAND+LOCATION_ONFIELD, 0, 1, 1, e:GetHandler())
			Duel.Destroy(g, REASON_EFFECT)
		else
			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_REMOVE)
			local g = Duel.SelectMatchingCard(tp, s.rmfilter_eff, tp, LOCATION_GRAVE, 0, 2, 2, nil)
			Duel.Remove(g, POS_FACEUP, REASON_EFFECT)
		end
	end

	-- 那之后，那些对方的效果无效并破坏
	if success then
		local ng = Group.CreateGroup()
		for j=1, ev do
			local p, re2 = Duel.GetChainInfo(j, CHAININFO_TRIGGERING_PLAYER, CHAININFO_TRIGGERING_EFFECT)
			if p == 1-tp then
				-- 手动拦截并无效当前堆栈上的这个有效连锁
				if Duel.NegateActivation(j) and re2:GetHandler():IsRelateToEffect(re2) then
					ng:AddCard(re2:GetHandler())
				end
			end
		end
		-- 将被无效的所有卡片一次性送去破坏
		if #ng > 0 then
			Duel.Destroy(ng, REASON_EFFECT)
		end
	end
end

-- === 效果②：回收 ===
function s.rmfilter_cost(c)
	return c:IsReason(REASON_DESTROY) and c:IsAbleToRemoveAsCost()
end

function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c = e:GetHandler()
	if chk==0 then 
		-- 此卡自身可以不用被视为被破坏的卡，只需自身能除外 + 另外两张是被破坏的即可满足语境要求
		return c:IsAbleToRemoveAsCost() and c:IsReason(REASON_DESTROY) and 
			   Duel.IsExistingMatchingCard(s.rmfilter_cost, tp, LOCATION_GRAVE, 0, 2, c)
	end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_REMOVE)
	local g = Duel.SelectMatchingCard(tp, s.rmfilter_cost, tp, LOCATION_GRAVE, 0, 2, 2, c)
	g:AddCard(c)
	Duel.Remove(g, POS_FACEUP, REASON_COST)
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	-- 除外动作完成后，那三张卡也在此搜索范围内，可以捞回刚刚被除外的那张自己
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand, tp, LOCATION_GRAVE+LOCATION_REMOVED, 0, 1, nil) end
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_GRAVE+LOCATION_REMOVED)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
	local g = Duel.SelectMatchingCard(tp, Card.IsAbleToHand, tp, LOCATION_GRAVE+LOCATION_REMOVED, 0, 1, 1, nil)
	if #g > 0 then
		Duel.SendtoHand(g, nil, REASON_EFFECT)
		Duel.ConfirmCards(1-tp, g)
	end
end