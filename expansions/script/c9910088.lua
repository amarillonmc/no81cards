--落樱之月神
function c9910088.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_HANDES+CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetCountLimit(1,9910088)
	e1:SetCost(c9910088.cost)
	e1:SetTarget(c9910088.target)
	e1:SetOperation(c9910088.operation)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_RELEASE)
	e2:SetCountLimit(1,9910089)
	e2:SetTarget(c9910088.thtg)
	e2:SetOperation(c9910088.thop)
	c:RegisterEffect(e2)
end
function c9910088.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c9910088.filter(c)
	return c:IsSetCard(0x9951) and not c:IsType(TYPE_TUNER) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9910088.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910088.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9910088.disfilter(c,tp)
	return c:IsSetCard(0x9951) and c:IsType(TYPE_MONSTER) and c:IsDiscardable(REASON_EFFECT)
		and Duel.IsExistingMatchingCard(c9910088.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,c)
end
function c9910088.sumfilter(c)
	return c:IsSummonable(true,nil) and c:IsRace(RACE_FAIRY)
end
function c9910088.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9910088.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if Duel.IsExistingMatchingCard(c9910088.disfilter,tp,LOCATION_HAND,0,1,nil,tp)
			and Duel.SelectYesNo(tp,aux.Stringid(9910088,0)) then
			Duel.BreakEffect()
			Duel.ShuffleHand(tp)
			if Duel.DiscardHand(tp,c9910088.disfilter,1,1,REASON_EFFECT+REASON_DISCARD,nil,tp)==0 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
			local sg=Duel.SelectMatchingCard(tp,c9910088.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
			local tc=sg:GetFirst()
			if tc then
				Duel.Summon(tp,tc,true,nil)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
				e1:SetValue(LOCATION_REMOVED)
				tc:RegisterEffect(e1,true)
			end
		end
	end
end
function c9910088.thfilter(c)
	return c:IsSetCard(0x9951) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c9910088.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c9910088.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9910088.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c9910088.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c9910088.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
