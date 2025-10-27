--星绘·奏曲
function c11185120.initial_effect(c)
	aux.AddCodeList(c,0x452)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c11185120.target)
	e1:SetOperation(c11185120.operation)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e2:SetCost(c11185120.cost)
	e2:SetTarget(c11185120.target)
	e2:SetOperation(c11185120.activate)
	c:RegisterEffect(e2)
end
function c11185120.filter(c)
	return c:IsSetCard(0x452) and not c:IsCode(11185120) and c:IsAbleToHand()
end
function c11185120.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11185120.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c11185120.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c11185120.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g)
		local cg=Duel.GetMatchingGroup(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,0,nil,0x452,1)
		if #cg>0 and Duel.SelectYesNo(tp,aux.Stringid(11185120,0)) then
			local tc=cg:GetFirst()
			while tc do
				tc:AddCounter(0x452,1)
				tc=cg:GetNext()
			end
		end
	end
end
function c11185120.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),tp,SEQ_DECKSHUFFLE,REASON_COST)
end
function c11185120.imcfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x452)
end
function c11185120.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard( c11185120.imcfilter,tp,0x4,0x4,1,nil) end
end
function c11185120.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp, c11185120.imcfilter,tp,0x4,0x4,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(c11185120.imfilter)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		tc:RegisterEffect(e1)
		if Duel.IsCanRemoveCounter(tp,1,0,0x452,1,0x40) and Duel.SelectYesNo(tp,aux.Stringid(11185120,1)) then
			Duel.BreakEffect()
			if not Duel.RemoveCounter(tp,1,0,0x452,1,0x40) then return end
			local g2=Duel.GetMatchingGroup(aux.AND(Card.IsSetCard,Card.IsFaceup),tp,0x4,0x4,nil,0x452)
			if #g2>0 and Duel.SelectYesNo(tp,aux.Stringid(11185120,2)) then
				local sc=g2:Select(tp,1,1,nil):GetFirst()
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetValue(500)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				sc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DIRECT_ATTACK)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				sc:RegisterEffect(e2)
			end
		end
	end 
end
function c11185120.imfilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer() and re:IsActivated()
end