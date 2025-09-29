--秘传·樱舞
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
		e1:SetCode(EVENT_CHAIN_SOLVING)
		e1:SetRange(LOCATION_PZONE)
		e1:SetCondition(s.lfcon)
		e1:SetOperation(s.lfop)
		c:RegisterEffect(e1)
		
end
function s.lfcon(e,tp,eg,ep,ev,re,r,rp)
	 
	return re and (re:GetHandler():IsCode(31740001) or aux.IsCodeListed(re:GetHandler(),31740001)) and re:GetHandlerPlayer()==tp
end
function s.lfop(e,tp,eg,ep,ev,re,r,rp)
		local g = Duel.GetMatchingGroup(s.skrfilter,tp,LOCATION_MZONE,0,nil)
		local c = e:GetHandler()
		if (#g~=0 and  Duel.SelectYesNo(tp,aux.Stringid(id,1))) and Duel.Destroy(c,REASON_EFFECT)~=0 then 
		local tc = g:Select(tp,1,1,nil):GetFirst()
		if not Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then return end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
		local e3 = Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_CAN_FORBIDDEN)
	e3:SetTarget(s.reptg)
	e3:SetValue(s.repval)
	tc:RegisterEffect(e3)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_REFLECT_DAMAGE)
	e2:SetValue(1)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(s.indcon)
	c:RegisterEffect(e2)
	
			local e1 = Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_CHAIN_END)
			e1:SetLabelObject(tc)
			e1:SetOperation(s.spop)
			e1:SetReset(RESET_PHASE + PHASE_END)
			Duel.RegisterEffect(e1, tp)
		end
end
function s.spop(e, tp, eg, ep, ev, re, r, rp)
	local tc = e:GetLabelObject()
	if tc and tc:IsLocation(LOCATION_SZONE) then
		Duel.SpecialSummon(tc, 0, tp, tp, false, false, POS_FACEUP)
	end
	e:Reset()
end
function s.indcon(e)
	return true
end
function s.repfilter(c, tp)
	return c:IsControler(1 - tp) and c:IsFaceup() and c:GetAttack() > 0 and c:IsReason(REASON_EFFECT)
		
end
function s.repfilter2(c, tp)
	return c:IsControler(1 - tp) and c:GetFlagEffect(id)~=0
		
end
function s.reptg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return eg:IsExists(s.repfilter, 1, nil, tp)
	end
	local pd = true
	local g = eg:Filter(s.repfilter, nil, tp)
	if #g ==0 then pd = false end 
	for tc in aux.Next(g) do
		-- 下降最多1000攻击力
		local down = math.min(1000, tc:GetAttack())
		local e1 = Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(-1500)
		e1:SetReset(RESET_EVENT + RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc:RegisterFlagEffect(id,RESET_CHAIN,0,1)
	end
	return pd
end

function s.repval(e, c)
	return s.repfilter2(c, e:GetHandlerPlayer())
end

function s.skrfilter(c)
	return c:IsCode(31740001) and c:IsFaceup()
end

-- 过滤器：有「只狼」卡名记述的灵摆怪兽
function s.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and aux.IsCodeListed(c,31740001) -- 假设0xfe是只狼系列的系列代码
end
function s.kfilter(c)
	return c:IsCode(31740003,31740007)
end
function s.excon(e, tp, eg, ep, ev, re, r, rp)
	return Duel.IsExistingMatchingCard(s.filter, tp, LOCATION_EXTRA, 0, 2, nil)
end

-- 目标：选择2张卡返回卡组，选择1只怪兽除外
function s.extg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.IsExistingMatchingCard(s.filter, tp, LOCATION_EXTRA, 0, 2, nil)
	end
	Duel.SetOperationInfo(0, CATEGORY_TODECK, nil, 2, tp, LOCATION_EXTRA)
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, 1-tp, LOCATION_MZONE)
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
		local rg = Duel.SelectMatchingCard(tp, Card.IsAbleToHand, tp, 0, LOCATION_MZONE, 1, 1, nil)
		if rg:GetCount() > 0 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
			local tc = rg:GetFirst()
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
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
	if Duel.Destroy(g,REASON_EFFECT)==2 and sg and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then 
		local tc = sg:Select(tp,1,1,nil)
		Duel.SendtoHand(tc,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function s.sfilter(c)
	return c:IsCode(31740001) or aux.IsCodeListed(c,31740001)
end