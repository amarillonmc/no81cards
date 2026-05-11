--桃绯术式 日轮之锁
function c9910541.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9910541,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c9910541.cost)
	e1:SetTarget(c9910541.target)
	e1:SetOperation(c9910541.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(9910541,ACTIVITY_CHAIN,aux.FALSE)
end
function c9910541.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c9910541.tgfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsAbleToGrave()
end
function c9910541.confilter(c)
	return c:IsSetCard(0xa950) and c:IsType(TYPE_MONSTER)
end
function c9910541.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c9910541.tgfilter,tp,LOCATION_DECK,0,1,nil)
		and (not e:IsCostChecked() or Duel.GetFlagEffect(tp,9910541)==0)
	local ch=Duel.GetCurrentChain()
	local b2=false
	if e:GetHandler():IsStatus(STATUS_CHAINING) then ch=ch-1 end
	local tse=nil
	if ch>0 then
		tse=Duel.GetChainInfo(ch,CHAININFO_TRIGGERING_EFFECT)
		local tep=Duel.GetChainInfo(ch,CHAININFO_TRIGGERING_PLAYER)
		b2=tse and tse:IsActiveType(TYPE_MONSTER) and tep==1-tp and Duel.IsChainDisablable(ev)
			and (not e:IsCostChecked() or Duel.GetFlagEffect(tp,9910542)==0
			and Duel.IsExistingMatchingCard(c9910541.confilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil))
	end
	if chk==0 then
		if e:GetLabel()~=0 then e:SetLabel(0) end
		return b1 or b2
	end
	local op=0
	if b1 or b2 then
		op=aux.SelectFromOptions(tp,{b1,aux.Stringid(9910541,1),1},{b2,aux.Stringid(9910541,2),2})
	end
	e:SetLabel(op)
	if op==1 then
		if e:IsCostChecked() then
			e:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SEARCH+CATEGORY_TOHAND)
			Duel.RegisterFlagEffect(tp,9910541,RESET_PHASE+PHASE_END,0,1)
		end
		e:SetOperation(c9910541.activate)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	elseif op==2 then
		if e:GetLabel()~=0 then
			e:SetLabel(0)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
			local g=Duel.SelectMatchingCard(tp,c9910541.confilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
			local tc=g:GetFirst()
			if tc:IsFaceup() then Duel.HintSelection(g)
			else Duel.ConfirmCards(1-tp,tc) end
			if tc:IsLocation(LOCATION_HAND) then
				Duel.ShuffleHand(tp)
				tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9910541,5))
			end
			tc:CreateEffectRelation(e)
			e:SetLabelObject(tc)
		end
		if e:IsCostChecked() then
			Duel.RegisterFlagEffect(tp,9910542,RESET_PHASE+PHASE_END,0,1)
			e:SetCategory(CATEGORY_DISABLE+CATEGORY_RELEASE)
		end
		e:SetOperation(c9910541.activate2)
		if tse then
			local og=Group.FromCards(tse:GetHandler())
			Duel.SetOperationInfo(0,CATEGORY_DISABLE,og,1,0,0)
		end
	end
end
function c9910541.thfilter(c)
	return c:IsRace(RACE_WARRIOR) and c:IsType(TYPE_RITUAL) and c:IsAbleToHand()
end
function c9910541.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9910541.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE)
		and Duel.GetCustomActivityCount(9910541,1-tp,ACTIVITY_CHAIN)~=0
		and Duel.IsExistingMatchingCard(c9910541.thfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(9910541,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,c9910541.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if sg:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
function c9910541.activate2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local ch=Duel.GetCurrentChain()
	local tse=Duel.GetChainInfo(ch-1,CHAININFO_TRIGGERING_EFFECT)
	if not tse then return end
	local rc=tse:GetHandler()
	if Duel.NegateEffect(ch-1) and rc:IsRelateToEffect(tse) and rc:IsReleasableByEffect()
		and tc and tc:IsRelateToEffect(e) and tc:IsReleasableByEffect() and tc~=rc
		and Duel.SelectYesNo(tp,aux.Stringid(9910541,4)) then
		Duel.BreakEffect()
		local g=Group.FromCards(tc,rc)
		Duel.Release(g,REASON_EFFECT)
	end
end
