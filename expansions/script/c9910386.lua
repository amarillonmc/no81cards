--月明夜的心声
function c9910386.initial_effect(c)
	aux.AddCodeList(c,9910376)
	--effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetHintTiming(TIMING_BATTLED,TIMINGS_CHECK_MONSTER+TIMING_BATTLED)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_CHAIN_END)
	e1:SetCountLimit(1,9910386+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c9910386.condition)
	e1:SetTarget(c9910386.target)
	e1:SetOperation(c9910386.activate)
	c:RegisterEffect(e1)
end
function c9910386.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)==0
end
function c9910386.spfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:GetSummonPlayer()~=tp
		and aux.disfilter1(c) and c:IsAbleToHand() and not c:IsDisabled()
end
function c9910386.summoncheck(tp)
	if not Duel.CheckEvent(EVENT_SUMMON_SUCCESS)
		and not Duel.CheckEvent(EVENT_SPSUMMON_SUCCESS) then return false end
	if Duel.CheckEvent(EVENT_SUMMON_SUCCESS) then
		local flag,eg,ep,ev,re,r,rp=Duel.CheckEvent(EVENT_SUMMON_SUCCESS,true)
		local tc=eg:GetFirst()
		return tc:IsLocation(LOCATION_MZONE) and ep~=tp
			and aux.disfilter1(tc) and tc:IsAbleToHand() and not tc:IsDisabled()
	else
		local flag,eg,ep,ev,re,r,rp=Duel.CheckEvent(EVENT_SPSUMMON_SUCCESS,true)
		return eg:IsExists(c9910386.spfilter,1,nil,tp)
	end
end
function c9910386.tgfilter(c)
	return c:IsCode(9910376) and c:IsAbleToGrave()
end
function c9910386.thfilter(c)
	return c:IsCode(9910376) and c:IsAbleToHand()
end
function c9910386.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=c9910386.summoncheck(tp)
		and Duel.IsExistingMatchingCard(c9910386.tgfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c9910386.thfilter,tp,LOCATION_GRAVE,0,1,nil)
	if chk==0 then return b1 or b2 end
	local s=0
	if b1 and not b2 then
		s=Duel.SelectOption(tp,aux.Stringid(9910386,0))
	end
	if not b1 and b2 then
		s=Duel.SelectOption(tp,aux.Stringid(9910386,1))+1
	end
	if b1 and b2 then
		s=Duel.SelectOption(tp,aux.Stringid(9910386,0),aux.Stringid(9910386,1))
	end
	if s==0 then
		e:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
		if Duel.CheckEvent(EVENT_SUMMON_SUCCESS) then
			e:SetLabel(1)
			local flag,eg2,ep2,ev2,re2,r2,rp2=Duel.CheckEvent(EVENT_SUMMON_SUCCESS,true)
			local tc=eg2:GetFirst()
			Duel.SetTargetCard(eg2)
			Duel.SetOperationInfo(0,CATEGORY_TOHAND,tc,1,0,0)
		else
			e:SetLabel(2)
			local flag,eg2,ep2,ev2,re2,r2,rp2=Duel.CheckEvent(EVENT_SPSUMMON_SUCCESS,true)
			local g=eg2:Filter(c9910386.spfilter,nil,tp)
			Duel.SetTargetCard(eg2)
			Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
		end
	end
	if s==1 then
		e:SetLabel(3)
		e:SetCategory(CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	end
end
function c9910386.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then
		local flag,eg2,ep2,ev2,re2,r2,rp2=Duel.CheckEvent(EVENT_SUMMON_SUCCESS,true)
		local tc=eg2:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tg=Duel.SelectMatchingCard(tp,c9910386.tgfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil)
		if tg:GetCount()>0 and Duel.SendtoGrave(tg,REASON_EFFECT)~=0 and tc and not tc:IsDisabled() then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			Duel.AdjustInstantly()
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	elseif e:GetLabel()==2 then
		local flag,eg2,ep2,ev2,re2,r2,rp2=Duel.CheckEvent(EVENT_SPSUMMON_SUCCESS,true)
		local g=eg2:Filter(c9910386.spfilter,nil,tp)
		local tc=g:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tg=Duel.SelectMatchingCard(tp,c9910386.tgfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil)
		if tg:GetCount()>0 and Duel.SendtoGrave(tg,REASON_EFFECT)~=0 and tc then
			if g:GetCount()>1 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
				tc=g:Select(tp,1,1,nil):GetFirst()
			end
			if not tc:IsDisabled() then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				Duel.AdjustInstantly()
				Duel.NegateRelatedChain(tc,RESET_TURN_SET)
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
			end
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c9910386.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetOperation(c9910386.chainop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c9910386.chainop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimit(c9910386.chainlm)
end
function c9910386.chainlm(e,rp,tp)
	return not e:GetHandler():IsType(TYPE_MONSTER)
end
