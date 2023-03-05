--惘然溯雪
function c9911168.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c9911168.target)
	e1:SetOperation(c9911168.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c9911168.handcon)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(c9911168.thcon)
	e3:SetCost(c9911168.thcost)
	e3:SetTarget(c9911168.thtg)
	e3:SetOperation(c9911168.thop)
	c:RegisterEffect(e3)
end
function c9911168.seqfilter(c)
	return c:GetSequence()<5
end
function c9911168.getct(tp)
	return 5-Duel.GetMatchingGroupCount(c9911168.seqfilter,tp,LOCATION_SZONE,0,nil)
end
function c9911168.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=c9911168.getct(tp)
	if chk==0 then
		if e:IsHasType(EFFECT_TYPE_ACTIVATE) and not e:GetHandler():IsLocation(LOCATION_SZONE) then ct=ct-1 end
		return ct>0 and ct==Duel.GetDecktopGroup(tp,ct):GetCount()
	end
	ct=c9911168.getct()
	local g=Duel.GetDecktopGroup(tp,ct)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c9911168.tgfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3958)
end
function c9911168.limfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
function c9911168.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=c9911168.getct(tp)
	if ct<=0 then return end
	local g=Duel.GetDecktopGroup(tp,ct)
	if #g==0 then return end
	Duel.DisableShuffleCheck()
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then
		local gt=0
		local og=Duel.GetOperatedGroup()
		if #og<=0 then return end
		Duel.HintSelection(og)
		local tg=og:Filter(c9911168.tgfilter,nil)
		if #tg>0 then gt=Duel.SendtoGrave(tg,REASON_EFFECT+REASON_RETURN) end
		og:Sub(tg)
		aux.PlaceCardsOnDeckBottom(tp,og)
		local mg=Duel.GetMatchingGroup(c9911168.limfilter,tp,0,LOCATION_MZONE,nil)
		if gt>0 and #mg>0 and Duel.SelectYesNo(tp,aux.Stringid(9911168,0)) then
			Duel.BreakEffect()
			local sg=mg:Select(tp,1,gt,nil)
			local tc=sg:GetFirst()
			while tc do
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CANNOT_TRIGGER)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1,true)
				tc=sg:GetNext()
			end
		end
	end
end
function c9911168.handcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)==0
end
function c9911168.thcon(e,tp,eg,ep,ev,re,r,rp)
	return aux.exccon(e) and Duel.GetTurnPlayer()==tp
		and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c9911168.costfilter(c)
	return c:IsSetCard(0x3958) and c:IsAbleToGraveAsCost()
end
function c9911168.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local fe=Duel.IsPlayerAffectedByEffect(tp,9911163)
	local b1=fe and Duel.IsExistingMatchingCard(c9911168.costfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and (b1 or b2) end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	if b1 and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(9911163,1))) then
		Duel.Hint(HINT_CARD,0,9911163)
		fe:UseCountLimit(tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c9911168.costfilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoGrave(g,REASON_COST)
	else
		Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
	end
end
function c9911168.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
		and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9911168.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	if g:GetCount()==0 then return end
	local tc=g:GetMinGroup(Card.GetSequence):GetFirst()
	Duel.DisableShuffleCheck()
	if Duel.SendtoHand(tc,tp,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,tc)
		Duel.ShuffleHand(tp)
	end
end
