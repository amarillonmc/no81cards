--绝望的机械死囚
function c9910909.initial_effect(c)
	aux.AddCodeList(c,9910871)
	aux.EnablePendulumAttribute(c)
	--revive limit
	aux.EnableReviveLimitPendulumSummonable(c,LOCATION_HAND)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.ritlimit)
	c:RegisterEffect(e0)
	--negate spell & trap
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c9910909.negcon1)
	e1:SetOperation(c9910909.negop1)
	c:RegisterEffect(e1)
	--negate monster
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c9910909.negcon2)
	e2:SetOperation(c9910909.negop2)
	c:RegisterEffect(e2)
	--return
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1)
	e3:SetTarget(c9910909.tgtg)
	e3:SetOperation(c9910909.tgop)
	c:RegisterEffect(e3)
end
function c9910909.negcon1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
	local sg=g:Filter(Card.IsFaceup,nil)
	return sg and sg:GetClassCount(Card.GetRace)>=3 and rp==1-tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
		and Duel.IsChainDisablable(ev) and Duel.GetFlagEffect(tp,9910909)==0
end
function c9910909.negop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(9910909,0)) then
		Duel.Hint(HINT_CARD,0,9910909)
		Duel.RegisterFlagEffect(tp,9910909,0,0,1)
		if Duel.NegateEffect(ev) then
			Duel.BreakEffect()
			Duel.Destroy(e:GetHandler(),REASON_EFFECT)
		end
	end
end
function c9910909.cfilter(c)
	return c:IsFaceup() and aux.IsCodeListed(c,9910871)
end
function c9910909.negcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(c9910909.cfilter,tp,LOCATION_MZONE,0,1,c)
		and rp==1-tp and Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)==LOCATION_MZONE 
		and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainDisablable(ev) and c:GetFlagEffect(9910910)==0
end
function c9910909.negop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(9910909,1)) then
		Duel.Hint(HINT_CARD,0,9910909)
		Duel.NegateEffect(ev)
		e:GetHandler():RegisterFlagEffect(9910910,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function c9910909.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c9910909.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and c9910909.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9910909.tgfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9910909,2))
	local g=Duel.SelectTarget(tp,c9910909.tgfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c9910909.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RETURN)~=0
		and c:IsRelateToEffect(e) and c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_RITUAL) then
		local race=tc:GetRace()
		if bit.band(c:GetRace(),race)~=race and Duel.SelectYesNo(tp,aux.Stringid(9910909,3)) then
			Duel.BreakEffect()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_ADD_RACE)
			e1:SetValue(race)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e1)
		end
	end
end
