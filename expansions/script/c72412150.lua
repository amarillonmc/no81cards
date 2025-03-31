--星宫守护者·白羊
function c72412150.initial_effect(c)
	aux.AddCodeList(c,72412160)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,72412150)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c72412150.discon)
	e1:SetCost(c72412150.discost)
	e1:SetTarget(c72412150.distg)
	e1:SetOperation(c72412150.disop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,72412151)
	e2:SetOperation(c72412150.regop)
	c:RegisterEffect(e2)
end
function c72412150.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function c72412150.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c72412150.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_HAND,0,1,e:GetHandler(),0x9728) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_HAND) 
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c72412150.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)~=0 then
		if not e:GetHandler():IsRelateToEffect(e) then return end
		local g=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_HAND,0,1,1,e:GetHandler(),0x9728)
		if g~=0 then
		Group.AddCard(g,e:GetHandler())
		Duel.SendtoGrave(g,REASON_EFFECT)   
		end
	end
end
function c72412150.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetLabel(Duel.GetTurnCount())
	e1:SetCondition(c72412150.thcon)
	e1:SetOperation(c72412150.thop)
	if Duel.GetCurrentPhase()<=PHASE_STANDBY then
		e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
	else
		e1:SetReset(RESET_PHASE+PHASE_STANDBY)
	end
	Duel.RegisterEffect(e1,tp)
end
function c72412150.thfilter(c,tp)
	local res=Duel.IsPlayerAffectedByEffect(tp,9911020) and c:IsSetCard(0x9728) and c:IsType(TYPE_MONSTER)
	local res2=Duel.GetFlagEffect(tp,72421261)<=0 and c:IsCode(72421260)
	return (c:IsCode(72412160) or res or res2) and c:IsAbleToHand()
end
function c72412150.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel() and Duel.IsExistingMatchingCard(c72412150.thfilter,tp,LOCATION_DECK,0,1,nil,tp)
end
function c72412150.thop(e,tp,eg,ep,ev,re,r,rp)
	Effect.Reset(e)
	Duel.Hint(HINT_CARD,0,72412150)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c72412150.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if g:GetFirst():GetCode()==72412160 and not Duel.IsPlayerAffectedByEffect(tp,9911020) then
		   Duel.RegisterFlagEffect(tp,72421261,RESET_PHASE+PHASE_END,0,1)
		end
	end
end
