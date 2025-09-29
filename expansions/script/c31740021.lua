--秘传·龙闪
local s,id,o = GetID()
function s.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	aux.AddCodeList(c,31740001)
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetCategory(CATEGORY_TOHAND + CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTarget(s.destg)
	e2:SetCondition(s.descon)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 1))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(s.pencost)
	e1:SetCondition(s.pencon)
	e1:SetTarget(s.pentg)
	e1:SetOperation(s.penop)
	c:RegisterEffect(e1)
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 1))
	e1:SetCategory(CATEGORY_TODECK + CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(s.excon)
	e1:SetTarget(s.extg)
	e1:SetOperation(s.exop)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,1))
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_ACTIVATING)
		e1:SetRange(LOCATION_PZONE)
		e1:SetCondition(s.lfcon)
		e1:SetOperation(s.lfop)
		c:RegisterEffect(e1)
		
end
function s.lfcon(e,tp,eg,ep,ev,re,r,rp)
	 
	return re and (re:GetHandler():IsCode(31740001) or aux.IsCodeListed(re:GetHandler(),31740001)) and re:GetHandlerPlayer()==tp
end
function s.lfop(e,tp,eg,ep,ev,re,r,rp)
		local c = e:GetHandler()
		if not Duel.SelectYesNo(tp,aux.Stringid(id,1)) or Duel.Destroy(c,REASON_EFFECT)==0 then return end
		local c = e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,1))
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_SOLVING)
		e1:SetReset(RESET_CHAIN)
		e1:SetTargetRange(1,0)
		e1:SetCondition(s.lfcon2)
		e1:SetOperation(s.lfop2)
		Duel.RegisterEffect(e1,tp)
	
	
end
function s.lfcon2(e,tp,eg,ep,ev,re,r,rp)
	 
	return re and (re:GetHandler():IsCode(31740001) or aux.IsCodeListed(re:GetHandler(),31740001)) and re:GetHandlerPlayer()==tp
end
function s.lfop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
	Duel.Hint(HINT_CARD,0,id)
		local g=Group.CreateGroup()
		Duel.ChangeTargetCard(0,g)
		Duel.ChangeChainOperation(0,s.repop)	
	end		
	
	
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,1))
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_SOLVING)
		e1:SetReset(RESET_CHAIN)
		e1:SetTargetRange(1,0)
		e1:SetCountLimit(1)
		e1:SetCondition(s.lfcon3)
		e1:SetOperation(s.lfop3)
		Duel.RegisterEffect(e1,tp)
	
	
end
function s.lfcon3(e,tp,eg,ep,ev,re,r,rp)
	 
	return re and (re:GetHandler():IsCode(31740001) or aux.IsCodeListed(re:GetHandler(),31740001)) and re:GetHandlerPlayer()==tp and Duel.GetFirstTarget()
end
function s.lfop3(e,tp,eg,ep,ev,re,r,rp)
Duel.Hint(HINT_CARD,0,id)

		local g=Group.CreateGroup()
		Duel.ChangeChainOperation(0,s.repop2)	
			
	
	
end
function s.excon(e, tp, eg, ep, ev, re, r, rp)
	return Duel.IsExistingMatchingCard(s.filter, tp, LOCATION_EXTRA, 0, 2, nil)
end
function s.repop2(e,tp,eg,ep,ev,re,r,rp)
		local c = e:GetHandler()
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		local sg=g:Filter(Card.IsRelateToEffect,nil,e)
		local cg = Group.CreateGroup()
		for tc in  aux.Next(sg) do
			cg:AddCard(tc)
			cg:Merge(tc:GetColumnGroup():Filter(Card.IsControler,nil,1-tp))
		end
		
		for tc in aux.Next(cg) do
			if tc:IsFaceup() and tc:IsCanBeDisabledByEffect(e) then
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3)
		end
		Duel.AdjustInstantly()
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		Duel.Destroy(tc,REASON_EFFECT)
	end
		end
	
end
-- 过滤器：有「只狼」卡名记述的灵摆怪兽
function s.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and aux.IsCodeListed(c,31740001) -- 假设0xfe是只狼系列的系列代码
end
function s.kfilter(c)
	return c:IsCode(31740003,31740007)
end

-- 目标：选择2张卡返回卡组，选择1只怪兽除外
function s.extg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.IsExistingMatchingCard(s.filter, tp, LOCATION_EXTRA, 0, 2, nil)
	end
	Duel.SetOperationInfo(0, CATEGORY_TODECK, nil, 2, tp, LOCATION_EXTRA)
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, 0, LOCATION_DECK)
end

-- 操作：将2张卡返回卡组，选择1只怪兽除外
function s.exop(e, tp, eg, ep, ev, re, r, rp)
	-- 选择2张有「只狼」卡名记述的灵摆怪兽
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TODECK)
	local g = Duel.SelectMatchingCard(tp, s.filter, tp, LOCATION_EXTRA, 0, 2, 2, nil)
	if g:GetCount() < 2 then return end
	
	-- 将选择的卡返回卡组
	if Duel.SendtoDeck(g, nil, SEQ_DECKSHUFFLE, REASON_EFFECT) > 0 then
		Duel.ShuffleDeck(tp)
		
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
		local rg = Duel.SelectMatchingCard(tp, s.kfilter, tp, LOCATION_DECK, 0, 1, 1, nil)
		if rg:GetCount() > 0 then
			local tc = rg:GetFirst()
			Duel.SendtoHand(tc,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end
function s.pencost(e, tp, eg, ep, ev, re, r, rp, chk)
	local c = e:GetHandler()
	if chk == 0 then return not e:GetHandler():IsPublic() end
	local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_PUBLIC)
				e1:SetDescription(66)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				c:RegisterEffect(e1)
end
function s.pencon(e, tp, eg, ep, ev, re, r, rp)
	return Duel.IsExistingMatchingCard(s.skrfilter, tp, LOCATION_MZONE, 0, 1, nil)
end
function s.skrfilter(c)
	return c:IsCode(31740001) and c:IsFaceup()
end
-- 代价：展示手牌的这张卡
-- 目标：检查右侧灵摆区域是否有卡
function s.pentg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return true -- 检查右侧灵摆区域
	end
end

-- 操作：将右侧灵摆区域的卡返回手牌并公开，然后将这张卡放置到右侧灵摆区域
function s.penop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	
	-- 获取右侧灵摆区域的卡
	local rpcard = Duel.GetFieldCard(tp, LOCATION_PZONE, 0)
	
	-- 如果右侧灵摆区域有卡，将其返回手牌并公开
	if rpcard then
		if Duel.SendtoHand(rpcard, tp, REASON_EFFECT) > 0 then
			-- 直到回合结束时公开
			local e1 = Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(id, 1))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetCode(EFFECT_PUBLIC)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			rpcard:RegisterEffect(e1)
		end
	end
	
	-- 将这张卡放置到右侧灵摆区域
	Duel.MoveToField(c, tp, tp, LOCATION_PZONE, POS_FACEUP, true)
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	local g=  Duel.GetMatchingGroup(nil,tp,LOCATION_PZONE,0,nil)
	return g:GetClassCount(Card.GetRightScale)==1 and #g==2
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=  Duel.GetMatchingGroup(s.ifilter,tp,LOCATION_PZONE,0,nil)
	if chk==0 then return #g==2 end
	Duel.SetOperationInfo(0, CATEGORY_DESTROY, g, 2, 0, 0)
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, 0, LOCATION_DECK)
	
	
end

function s.ifilter(c)
	return c:IsDestructable()
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=  Duel.GetMatchingGroup(nil,tp,LOCATION_PZONE,0,nil)
	local sg = Duel.GetMatchingGroup(s.sfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if Duel.Destroy(g,REASON_EFFECT)==2 and sg and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then 
		local tc = sg:Select(tp,1,1,nil)
		Duel.SendtoHand(tc,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function s.sfilter(c)
	return c:IsCode(31740001) or aux.IsCodeListed(c,31740001)
end