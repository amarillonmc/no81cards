--楔丸·攻击
local s,id,o = GetID()
local a = 31800000
local d = 31700000
function s.initial_effect(c)
	aux.AddCodeList(c,31740001)
	-- ① 双方回合破坏对方怪兽（手牌发动）
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 4))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	--e1:SetCountLimit(1, EFFECT_COUNT_CODE_CHAIN)
	e1:SetCondition(s.descon)
	e1:SetCost(s.descost)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
	
	-- ② 展示并返回卡组，检索/特召
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 5))
	e2:SetCategory(CATEGORY_TODECK + CATEGORY_TOHAND + CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCost(s.thcost)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end

-- 效果①条件：场上有「只狼」表侧表示
function s.descon(e, tp, eg, ep, ev, re, r, rp)
return Duel.IsExistingMatchingCard(s.skrfilter, tp, LOCATION_MZONE, 0, 1, nil) and Duel.GetChainInfo(Duel.GetCurrentChain(),CHAININFO_TRIGGERING_CODE)~=e:GetHandler():GetCode()
end
function s.skrfilter(c)
	return c:IsCode(31740001) and c:IsFaceup()
end
-- 效果①代价：展示手牌
function s.descost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return true end
	Duel.ConfirmCards(1-tp, e:GetHandler())
end

-- 效果①目标：选择对方场上1只怪兽
function s.destg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsExistingTarget(Card.IsFaceup, tp, 0, LOCATION_MZONE, 1, nil) and Duel.GetFlagEffect(tp,a+Duel.GetCurrentChain()+1)==0 end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DESTROY)
	local g = Duel.SelectTarget(tp, Card.IsFaceup, tp, 0, LOCATION_MZONE, 1, 1, nil)
	Duel.SetOperationInfo(0, CATEGORY_DESTROY, g, 1, 0, 0)
end

-- 效果①操作：破坏选择的怪兽
function s.desop(e, tp, eg, ep, ev, re, r, rp)
	local tc = Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc, REASON_EFFECT)
		Duel.RegisterFlagEffect(tp,a+Duel.GetCurrentChain(),RESET_PHASE+PHASE_END,0,1)
		Duel.ResetFlagEffect(tp,d+Duel.GetCurrentChain())
	end
end

-- 效果②代价：展示手牌中的「楔丸·攻击」和「楔丸·防御」
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
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
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
			local op = Duel.SelectOption(tp, aux.Stringid(id, 2), aux.Stringid(id, 3))
			if op == 0 then
				Duel.SendtoHand(tc, nil, REASON_EFFECT)
				Duel.ConfirmCards(1-tp, tc)
			else
				Duel.SpecialSummon(tc, 0, tp, tp, false, false, POS_FACEUP)
			end
		end
	end
end

-- 检索过滤器：只狼或有只狼卡名记述的楔丸攻击/防御以外的怪兽
function s.filter(c)
	return c:IsCode(31740001) or 
		   aux.IsCodeListed(c,31740001) and  c:IsType(TYPE_MONSTER) and not c:IsCode(31740005, 31740006)
		   
end