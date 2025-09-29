--医师 永真
local s, id = GetID()

function s.initial_effect(c)
	aux.AddCodeList(c,31740001)
	-- ① 将手卡返回卡组并检索只狼魔法陷阱
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_TODECK + CATEGORY_TOHAND + CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	--e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(s.cost)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	local e3 = e1:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCondition(s.condition2)
	c:RegisterEffect(e3)
	if not s.global_check then
		s.global_check=true
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,1))
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_LEAVE_FIELD)
		e1:SetCondition(s.lfcon)
		e1:SetOperation(s.lfop2)
		Duel.RegisterEffect(e1,0)
	end
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(s.aihcon)
	e2:SetTarget(s.aihtg)
	e2:SetTargetRange(LOCATION_HAND,0)
	c:RegisterEffect(e2)
	e3 = e2:Clone()
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e3)
end
function s.aihcon(e, tp, eg, ep, ev, re, r, rp)
	return e:GetHandler():IsPublic()
end
function s.aihtg(e,c)
	return aux.IsCodeListed(c,31740001)
end
function s.cost(e, tp, eg, ep, ev, re, r, rp, chk)
	local c = e:GetHandler()
	if chk == 0 then
		return not c:IsPublic()
	end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(66)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_PUBLIC)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				c:RegisterEffect(e1)
end
function s.lfcon(e,tp,eg,ep,ev,re,r,rp)
	 
	return re and re:GetHandler():IsCode(31740001)
end
function s.lfop2(e,tp,eg,ep,ev,re,r,rp)
		local g = Group.Clone(eg)
		for tc in aux.Next(g) do
			Duel.RegisterFlagEffect(1-tc:GetOwner(),id,RESET_PHASE+PHASE_END,0,0)
		end
		
			
	
	
end
function s.condition2(e, tp, eg, ep, ev, re, r, rp)
	return Duel.GetFlagEffect(tp,id) ~=0
end

-- 条件：自己回合的主要阶段
function s.condition(e, tp, eg, ep, ev, re, r, rp)
	return Duel.GetFlagEffect(tp,id) ==0
end

-- 目标：选择手卡返回卡组
function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck, tp, LOCATION_HAND, 0, 1, e:GetHandler()) end
	Duel.SetOperationInfo(0, CATEGORY_TODECK, nil, 1, tp, LOCATION_HAND)
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
end

-- 操作：将手卡返回卡组并检索
function s.activate(e, tp, eg, ep, ev, re, r, rp)
	-- 选择1张手卡返回卡组
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TODECK)
	local g = Duel.SelectMatchingCard(tp, Card.IsAbleToDeck, tp, LOCATION_HAND, 0, 1, 1, e:GetHandler())
	if g:GetCount() == 0 then return end
	
	if Duel.SendtoDeck(g, nil, SEQ_DECKSHUFFLE, REASON_EFFECT) > 0 then
		Duel.ShuffleDeck(tp)
		
		-- 检索卡组中有「只狼」卡名记述的魔法·陷阱卡
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
		local sg = Duel.SelectMatchingCard(tp, s.thfilter, tp, LOCATION_DECK, 0, 1, 1, nil)
		if sg:GetCount() > 0 then
			Duel.SendtoHand(sg, nil, REASON_EFFECT)
			Duel.ConfirmCards(1-tp, sg)
		end
	end
end

-- 过滤器：有「只狼」卡名记述的魔法·陷阱卡
function s.thfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and aux.IsCodeListed(c,31740001) and c:IsAbleToHand()
end