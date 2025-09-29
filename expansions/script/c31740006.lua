--楔丸·防御
local s,id,o = GetID()
local a = 31800000
local d = 31700000
function s.initial_effect(c)
	aux.AddCodeList(c,31740001)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(84815190,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(s.descon)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetCategory(CATEGORY_TODECK + CATEGORY_TOHAND + CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCost(s.thcost)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end
function s.thcost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		local g = Duel.GetMatchingGroup(s.cfilter, tp, LOCATION_HAND, 0, nil, 31740005, 31740006)
		return #g>=2
	end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_CONFIRM)
	local g = Duel.SelectMatchingCard(tp, s.cfilter, tp, LOCATION_HAND, 0, 2, 2, nil, 31740005, 31740006)
	Duel.ConfirmCards(1-tp, g)
	g:KeepAlive()
	e:SetLabelObject(g)
end
function s.cfilter(c)
	return c:IsCode(31740005,31740006) and not c:IsPublic()
end

-- 效果②目标：设置操作信息
function s.thtg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0, CATEGORY_TODECK, nil, 2, tp, LOCATION_HAND)
	Duel.SetOperationInfo(0, CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_DECK)
end

-- 效果②操作：返回卡组，检索/特召
function s.thop(e, tp, eg, ep, ev, re, r, rp)
	local g = e:GetLabelObject()
	if not g or g:GetCount() < 2 then return end
	
	-- 将卡返回卡组洗切
	if Duel.SendtoDeck(g, nil, SEQ_DECKSHUFFLE, REASON_EFFECT) > 0 then
		Duel.ShuffleDeck(tp)
		
		-- 从卡组选择1只符合条件的怪兽
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
		local sg = Duel.SelectMatchingCard(tp, s.filter, tp, LOCATION_DECK, 0, 1, 1, nil)
		if sg:GetCount() > 0 then
			local tc = sg:GetFirst()
			-- 选择加入手卡或特殊召唤
			
			
				Duel.SendtoHand(tc, nil, REASON_EFFECT)
				Duel.ConfirmCards(1-tp, tc)
			
		end
	end
end

-- 检索过滤器：只狼或有只狼卡名记述的楔丸攻击/防御以外的怪兽
function s.filter(c)
	return c:IsCode(31740001) or 
		   aux.IsCodeListed(c,31740001) and  not c:IsType(TYPE_MONSTER) and not c:IsCode(31740005,31740006) 
		   
end
-- 效果①条件：场上有「只狼」表侧表示
function s.descon(e, tp, eg, ep, ev, re, r, rp)
	return Duel.IsExistingMatchingCard(s.skrfilter, tp, LOCATION_MZONE, 0, 1, nil) and re:GetHandlerPlayer()==1-tp
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,d+Duel.GetCurrentChain()+1)==0 and Duel.IsExistingMatchingCard(s.pfilter,tp,LOCATION_HAND,0,1,nil) end
	
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
	if Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		local pc = Duel.SelectMatchingCard(tp,s.pfilter,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)	
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetDescription(66)
				e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		pc:RegisterEffect(e1)
		e:SetLabelObject(pc)
		
	
	else	
		local pc = Duel.SelectMatchingCard(tp,s.pfilter,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetDescription(66)
				e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
		pc:RegisterEffect(e1)
		e:SetLabelObject(pc)
	end
end
function s.pfilter(c)
	return aux.IsCodeListed(c,31740001) and not c:IsPublic()
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local pc  = e:GetLabelObject()
	local c= e:GetHandler()
	if pc and pc:GetOriginalType()&TYPE_MONSTER|TYPE_SPELL|TYPE_TRAP == re:GetHandler():GetOriginalType()&TYPE_MONSTER|TYPE_SPELL|TYPE_TRAP and Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then 
		Duel.Destroy(eg,REASON_EFFECT)
	end
	if (not pc) or pc:GetOriginalType()&TYPE_MONSTER|TYPE_SPELL|TYPE_TRAP ~= re:GetHandler():GetOriginalType()&TYPE_MONSTER|TYPE_SPELL|TYPE_TRAP then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_IMMUNE_EFFECT)
		e2:SetTargetRange(LOCATION_MZONE,0)
		e2:SetReset(RESET_CHAIN)
		e2:SetValue(s.efilter)
		e2:SetTarget(s.indtg)
		e2:SetLabelObject(re)
		Duel.RegisterEffect(e2,tp)
		Duel.RegisterFlagEffect(tp,d+Duel.GetCurrentChain(),RESET_PHASE+PHASE_END,0,1)
	end
	Duel.RegisterFlagEffect(tp,d+Duel.GetCurrentChain(),RESET_PHASE+PHASE_END,0,1)
		Duel.ResetFlagEffect(tp,a+Duel.GetCurrentChain())
end
function s.indtg(e,c)
	return c:IsCode(31740001) and c:IsFaceup()
end
function s.efilter(e,te)
	return te == e:GetLabelObject()
end
function s.skrfilter(c)
	return c:IsCode(31740001) and c:IsFaceup()
end