local s, id = GetID()

function s.initial_effect(c)
	-- ① 双方回合各1次破坏对方表侧怪兽
	c:SetUniqueOnField(1,0,id)
	local e1 = Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)

	-- ② 离场时特殊召唤自身（展示手卡）
	local e2 = Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCountLimit(1, id)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)

	-- ③ 攻击力不为0的怪兽破坏时代替下降攻击力（不会被无效化）
	local e3 = Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_CAN_FORBIDDEN)
	e3:SetTarget(s.reptg)
	e3:SetValue(s.repval)
	e3:SetOperation(s.repop)
	c:RegisterEffect(e3)
end

-- 效果①：破坏对方表侧怪兽
function s.destg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.IsExistingTarget(Card.IsFaceup, tp, 0, LOCATION_MZONE, 1, nil)
	end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DESTROY)
	local g = Duel.SelectTarget(tp, Card.IsFaceup, tp, 0, LOCATION_MZONE, 1, 1, nil)
	Duel.SetOperationInfo(0, CATEGORY_REMOVE, g, 1, 0, 0)
end

function s.desop(e, tp, eg, ep, ev, re, r, rp)
	local tc = Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e)  then 
		Duel.Destroy(tc,REASON_EFFECT)
	end
	if tc and tc:IsRelateToEffect(e) and tc:GetAttack()==0 then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end

-- 效果②：离场特殊召唤自身
function s.spcon(e, tp, eg, ep, ev, re, r, rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP)
end

function s.filter(c, e, tp)
	return aux.IsCodeListed(c,31740001) 
end
function s.filter2(c, e, tp)
	return aux.IsCodeListed(c,31740001) and not c:IsType(TYPE_MONSTER)
end

function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
			and e:GetHandler():IsCanBeSpecialSummoned(e, 0, tp, false, false)
			and Duel.IsExistingMatchingCard(s.filter, tp, LOCATION_HAND, 0, 1, nil, e, tp)
	end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, e:GetHandler(), 1, 0, 0)
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
end

function s.spop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if Duel.GetLocationCount(tp, LOCATION_MZONE) <= 0 then
		return
	end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_CONFIRM)
	local g = Duel.SelectMatchingCard(tp, s.filter, tp, LOCATION_HAND, 0, 1, 1, nil, e, tp)
	if #g > 0 then
		
		if c:IsRelateToEffect(e)  then
		Duel.ConfirmCards(1 - tp, g)	
			Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP) 
			
			-- 本回合不能发动展示的卡及同名卡
			local code = g:GetFirst():GetCode()
			local e1 = Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1, 0)
			e1:SetValue(function(e, re, tp)
				return re:GetHandler():IsCode(code)
			end)
			e1:SetReset(RESET_PHASE + PHASE_END)
			Duel.RegisterEffect(e1, tp)
			local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.filter2),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
			if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
				local tc = g:Select(tp,1,1,nil):GetFirst()
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tc)
				
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_PUBLIC)
				e1:SetDescription(66)
				e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1)
			end
		end
	end
end

-- 效果③：代替破坏并下降攻击力
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
		e1:SetValue(-1000)
		e1:SetReset(RESET_EVENT + RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc:RegisterFlagEffect(id,RESET_CHAIN,0,1)
	end
	return pd
end

function s.repval(e, c)
	return s.repfilter2(c, e:GetHandlerPlayer())
end

function s.repop(e, tp, eg, ep, ev, re, r, rp)
	
end