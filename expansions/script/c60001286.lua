local s, id = GetID()
function s.initial_effect(c)
	-- 手卡发动
	local e0 = Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e0:SetCondition(s.handcon)
	c:RegisterEffect(e0)
	-- 效果①
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	--e1:SetCountLimit(1, id + EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.sumtg)
	e1:SetOperation(s.sumop)
	c:RegisterEffect(e1)
	-- 效果②
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	--e2:SetCountLimit(1, id + 100)
	e2:SetCost(s.thcost)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end
--场上有4星以下风属性怪兽
function s.windfilter(c)
	return c:IsType(TYPE_MONSTER)
		and c:IsAttribute(ATTRIBUTE_WIND)
		and c:IsLevelBelow(4)
end

function s.handcon(e)
	return Duel.IsExistingMatchingCard(s.windfilter, e:GetHandlerPlayer(), LOCATION_MZONE, 0, 1, nil)
end

--召唤5星以上风属性怪兽
function s.sumfilter(c)
	return c:IsType(TYPE_MONSTER)   
		and c:IsAttribute(ATTRIBUTE_WIND)
		and c:IsLevelAbove(5)
		and c:IsSummonable(true, nil)
end

function s.sumtg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.IsExistingMatchingCard(s.sumfilter, tp, LOCATION_HAND, 0, 1, nil)
	end
	Duel.SetOperationInfo(0, CATEGORY_SUMMON, nil, 1, 0, 0)
	
	-- 不能被连锁
	local e1 = Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetOperation(s.chainop)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1, tp)
end

function s.chainop(e, tp, eg, ep, ev, re, r, rp)
	if re:GetHandler() == e:GetHandler() and re:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(s.chainlm)
	end
end

function s.chainlm(e, rp, tp)
	return tp == rp
end

function s.sumop(e, tp, eg, ep, ev, re, r, rp)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SUMMON)
	local g = Duel.SelectMatchingCard(tp, s.sumfilter, tp, LOCATION_HAND, 0, 1, 1, nil)
	local tc = g:GetFirst()
	if tc then
		Duel.Summon(tp, tc, true, nil)
	end
end

-- 效果②
function s.costfilter(c, tp)
	return c:IsReleasable() 
		and c:GetSummonType() == SUMMON_TYPE_ADVANCE  
end

function s.thcost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.CheckReleaseGroup(tp, s.costfilter, 1, nil, tp)
	end
	local g = Duel.SelectReleaseGroup(tp, s.costfilter, 1, 1, nil, tp)
	Duel.Release(g, REASON_COST)
end

function s.thtg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return e:GetHandler():IsAbleToHand()
	end
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, e:GetHandler(), 1, 0, 0)
end

function s.thop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c, nil, REASON_EFFECT) > 0 then
		Duel.ConfirmCards(1 - tp, c)
		
		-- 可以用对方怪兽代替解放
		local e1 = Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_EXTRA_RELEASE_SUBSTITUTE)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetTargetRange(0, LOCATION_MZONE) 
		e1:SetCountLimit(1,m)
		e1:SetTarget(s.releasetg)
		e1:SetValue(s.releaseval)
		--e1:SetReset(RESET_PHASE + PHASE_END, 2)
		Duel.RegisterEffect(e1, tp)
	end
end

function s.releasetg(e, c)
	return c:IsType(TYPE_MONSTER) and c:IsControler(1 - e:GetHandlerPlayer())
end

function s.releaseval(e, re, r, rp)
	return r & REASON_SUMMON ~= 0
end