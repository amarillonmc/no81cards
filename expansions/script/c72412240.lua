--星宫守护者·摩羯
function c72412240.initial_effect(c)
	aux.AddCodeList(c,72412250)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_SPSUMMON)
	e1:SetCountLimit(1,72412240)
	e1:SetCondition(c72412240.discon)
	e1:SetCost(c72412240.discost)
	e1:SetTarget(c72412240.distg)
	e1:SetOperation(c72412240.disop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,72412241)
	e2:SetOperation(c72412240.regop)
	c:RegisterEffect(e2)
end
function c72412240.discon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and Duel.GetCurrentChain()==0
end
function c72412240.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c72412240.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_HAND,0,1,e:GetHandler(),0x9728) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_HAND)	
end
function c72412240.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		if not e:GetHandler():IsRelateToEffect(e) then return end
		local g=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_HAND,0,1,1,e:GetHandler(),0x9728)
		if g~=0 then
		Group.AddCard(g,e:GetHandler())
		Duel.SendtoGrave(g,REASON_EFFECT)   
		end
end
function c72412240.thfilter1(c)
	return c:IsCode(72412250) or (Duel.IsPlayerAffectedByEffect(c:GetOwner(),72412340) and c:IsSetCard(0x9728))
end
function c72412240.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,72412240,RESET_PHASE+PHASE_END,0,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetCondition(c72412240.thcon)
	e1:SetOperation(c72412240.thop)
	Duel.RegisterEffect(e1,tp)
end
function c72412240.thfilter2(c)
	return c72412240.thfilter1(c) and c:IsAbleToHand()
end
function c72412240.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c72412240.thfilter2),tp,LOCATION_DECK,0,1,nil) and Duel.GetFlagEffect(tp,72412240)==0
end
function c72412240.thop(e,tp,eg,ep,ev,re,r,rp)
	Effect.Reset(e)
	Duel.Hint(HINT_CARD,0,72412240)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c72412240.thfilter2),tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
