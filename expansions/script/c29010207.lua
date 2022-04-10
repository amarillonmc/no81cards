--解脱？
function c29010207.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,29010207+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c29010207.cost)
	e1:SetOperation(c29010207.operation)
	c:RegisterEffect(e1)
	--xx
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_SEND_REPLACE)
	e2:SetTarget(c29010207.reptg)
	e2:SetValue(c29010207.repval)
	c:RegisterEffect(e2)
end
function c29010207.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c29010207.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetLabel(Duel.GetTurnCount())
	e1:SetCondition(c29010207.drcon)
	e1:SetOperation(c29010207.drop)
	if Duel.GetCurrentPhase()<=PHASE_STANDBY then
		e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
	else
		e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
	end
	Duel.RegisterEffect(e1,tp)
end
function c29010207.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel() and Duel.IsPlayerCanDraw(tp,2) and Duel.GetTurnPlayer()==tp 
end
function c29010207.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,29010207)
	if Duel.SelectYesNo(tp,aux.Stringid(29010207,0)) then 
	Duel.Draw(tp,2,REASON_EFFECT)
	end
end
function c29010207.repfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_DECK) and c:GetDestination()==LOCATION_HAND and c:IsCode(29010200)
end
function c29010207.thfil(c)
	return c:IsAbleToHand() and c:IsCode(29010204) 
end
function c29010207.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return bit.band(r,REASON_EFFECT)~=0 and re and eg:IsExists(c29010207.repfilter,1,nil,tp) and Duel.IsExistingMatchingCard(c29010207.thfil,tp,LOCATION_DECK,0,1,nil) and e:GetHandler():GetFlagEffect(29010207)==0 end
	if Duel.SelectYesNo(tp,aux.Stringid(29010207,1)) then
	e:GetHandler():RegisterFlagEffect(29010207,RESET_EVENT+RESETS_STANDARD,0,1) 
		local g=eg:Filter(c29010207.repfilter,nil,tp)
		local ct=g:GetCount()
		if ct>1 then
			g=g:Select(tp,1,ct,nil)
		end
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TO_HAND_REDIRECT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(LOCATION_GRAVE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)	   
			tc=g:GetNext()
		end
		local g1=Duel.GetMatchingGroup(c29010207.thfil,tp,LOCATION_DECK,0,nil) 
		local sg=g1:Select(tp,1,ct,nil) 
		Duel.SendtoHand(sg,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		return true
	else return false end
end
function c29010207.repval(e,c)
	return false
end











