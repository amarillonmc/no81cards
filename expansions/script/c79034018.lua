--Hollow Knight-螳螂领主
function c79034018.initial_effect(c)
	--banish & search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79034018,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,79034018)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c79034018.thtg)
	e1:SetOperation(c79034018.thop)
	c:RegisterEffect(e1)  
	--link summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65741786,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c79034018.lkcon)
	e2:SetCost(c79034018.lkcost)
	e2:SetTarget(c79034018.lktg)
	e2:SetOperation(c79034018.lkop)
	c:RegisterEffect(e2)
end
function c79034018.rmfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xca9) and c:IsAbleToRemove()
end
function c79034018.thfilter(c)
	return c:IsSetCard(0xca9) and c:IsType(TYPE_MONSTER) and not c:IsCode(79034018) and c:IsAbleToHand()
end
function c79034018.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c79034018.rmfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c79034018.rmfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c79034018.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c79034018.rmfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c79034018.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)~=0
		and tc:IsLocation(LOCATION_REMOVED) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(28692962,1))
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetLabelObject(tc)
		e1:SetCountLimit(1)
		e1:SetCondition(c79034018.retcon)
		e1:SetOperation(c79034018.retop)
		if Duel.GetTurnPlayer()==tp then
		e1:SetValue(0)
		e1:SetReset(RESET_PHASE+PHASE_STANDBY)
		tc:RegisterFlagEffect(79034018,RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,1)
		else
		e1:SetValue(Duel.GetTurnCount())
		e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
		tc:RegisterFlagEffect(79034018,RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,2)end
		Duel.RegisterEffect(e1,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c79034018.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c79034018.retcon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetValue()==Duel.GetTurnCount() then return false
	else
	return e:GetLabelObject():GetFlagEffect(79034018)~=0
end
end
function c79034018.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.ReturnToField(tc)
end
function c79034018.lkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
		and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c79034018.cfilter(c)
	return c:IsSetCard(0xca9) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c79034018.lkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79034018.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	local g=Duel.SelectMatchingCard(tp,c79034018.cfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function c79034018.lktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,1,nil,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c79034018.lkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsControler(1-tp) or not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,nil,nil,c)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.LinkSummon(tp,sg:GetFirst(),nil,c)
	end
end


