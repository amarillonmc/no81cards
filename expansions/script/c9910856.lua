--千恋触雪
function c9910856.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,9910856)
	e1:SetTarget(c9910856.target)
	e1:SetOperation(c9910856.activate)
	c:RegisterEffect(e1)
	--summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMING_BATTLE_START)
	e2:SetCountLimit(1,9910860)
	e2:SetCondition(c9910856.sumcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c9910856.sumtg)
	e2:SetOperation(c9910856.sumop)
	c:RegisterEffect(e2)
end
function c9910856.cfilter1(c)
	return c:IsSetCard(0xa951) and c:IsAbleToHand()
end
function c9910856.cfilter2(c)
	return c:IsSetCard(0xa951) and c:IsAbleToRemove()
end
function c9910856.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local dg=Duel.GetMatchingGroup(aux.disfilter1,tp,0,LOCATION_ONFIELD,nil)
	local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(EVENT_CHAINING,true)
	local b1=res and trp~=tp and Duel.IsExistingMatchingCard(c9910856.cfilter1,tp,LOCATION_DECK,0,1,nil)
	local b2=dg:GetCount()>0
		and Duel.IsExistingMatchingCard(c9910856.cfilter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,c)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_MAIN1 then
			op=Duel.SelectOption(tp,aux.Stringid(9910856,0),aux.Stringid(9910856,1),aux.Stringid(9910856,2))
		else
			op=Duel.SelectOption(tp,aux.Stringid(9910856,0),aux.Stringid(9910856,1))
		end
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(9910856,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(9910856,1))+1
	end
	e:SetLabel(op)
	if op~=1 then
		Duel.SetTargetCard(tre:GetHandler())
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
		if op==0 then
			e:SetCategory(CATEGORY_TOHAND)
		else
			e:SetCategory(CATEGORY_TOHAND+CATEGORY_REMOVE+CATEGORY_DISABLE)
			Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,LOCATION_HAND+LOCATION_GRAVE)
			Duel.SetOperationInfo(0,CATEGORY_DISABLE,dg,0,0,0)
		end
	else
		e:SetCategory(CATEGORY_REMOVE+CATEGORY_DISABLE)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,LOCATION_HAND+LOCATION_GRAVE)
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,dg,0,0,0)
	end
end
function c9910856.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dg=Duel.GetMatchingGroup(aux.disfilter1,tp,0,LOCATION_ONFIELD,nil)
	local op=e:GetLabel()
	if op~=1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c9910856.cfilter1,tp,LOCATION_DECK,0,1,1,nil)
		local tc=g:GetFirst()
		local rc=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):GetFirst()
		if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND)
			and rc and rc:IsRelateToEffect(e) and rc:IsOnField() and rc:IsFaceup() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_TRIGGER)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			rc:RegisterEffect(e1)
		end
	end
	if op~=0 then
		local ct=dg:GetCount()
		if ct>2 then ct=2 end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c9910856.cfilter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,ct,nil)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		local rct=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_REMOVED)
		if rct>0 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9910856,3))
			local sg=dg:Select(tp,rct,rct,nil)
			Duel.HintSelection(sg)
			local tc=sg:GetFirst()
				while tc do
				Duel.NegateRelatedChain(tc,RESET_TURN_SET)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetValue(RESET_TURN_SET)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e2)
				if tc:IsType(TYPE_TRAPMONSTER) then
					local e3=Effect.CreateEffect(c)
					e3:SetType(EFFECT_TYPE_SINGLE)
					e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
					e3:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e3)
				end
				tc=sg:GetNext()
			end
		end
	end
	if op==2 and Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_MAIN1 then
		Duel.BreakEffect()
		Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
		Duel.SkipPhase(tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
		Duel.SkipPhase(tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	end
end
function c9910856.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
end
function c9910856.sumfilter(c)
	return c:IsSetCard(0xa951) and c:IsSummonable(true,nil)
end
function c9910856.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910856.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c9910856.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c9910856.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end
