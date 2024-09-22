--折纸使 朱雀院椿
function c9910002.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--pendulum set
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,9910002)
	e1:SetCondition(c9910002.rpcon)
	e1:SetTarget(c9910002.rptg)
	e1:SetOperation(c9910002.rpop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,9910003)
	e2:SetCost(c9910002.thcost)
	e2:SetTarget(c9910002.thtg)
	e2:SetOperation(c9910002.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c9910002.rpcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(nil,tp,LOCATION_PZONE,0,1,e:GetHandler())
end
function c9910002.rpfilter(c)
	return c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c9910002.rpsfilter(c)
	return c9910002.rpfilter(c) and c:IsSetCard(0x3950) and not c:IsCode(9910002)
end
function c9910002.rptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910002.rpfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c9910002.rpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)>0 then
		if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,c9910002.rpfilter,tp,LOCATION_HAND,0,1,1,nil)
		if g:GetCount()==0 then return end
		local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
		local sg=Duel.GetMatchingGroup(c9910002.rpsfilter,tp,LOCATION_DECK,0,nil)
		if sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9910002,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
			local tg=sg:Select(tp,1,1,nil)
			local fc=tg:GetFirst()
			Duel.BreakEffect()
			Duel.MoveToField(fc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	end
end
function c9910002.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c9910002.thfilter(c)
	return c:IsCode(9910017,9910031) and c:IsAbleToHand()
end
function c9910002.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910002.thfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9910002.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9910002.thfilter),tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetCondition(c9910002.thcon2)
		e1:SetOperation(c9910002.thop2)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c9910002.thfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c9910002.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9910002.thfilter2,tp,LOCATION_EXTRA,0,1,nil)
end
function c9910002.thop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(9910002,4)) then
		Duel.Hint(HINT_CARD,0,9910002)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c9910002.thfilter2,tp,LOCATION_EXTRA,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
