--雪狱之罪证 善恶的考验
function c9911359.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9911359)
	e1:SetTarget(c9911359.target)
	e1:SetOperation(c9911359.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,9911360)
	e2:SetCondition(c9911359.thcon)
	e2:SetCost(c9911359.thcost)
	e2:SetTarget(c9911359.thtg)
	e2:SetOperation(c9911359.thop)
	c:RegisterEffect(e2)
end
function c9911359.spfilter(c,e,tp)
	return c:IsSetCard(0xc956) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9911359.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c9911359.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:GetClassCount(Card.GetCode)>=2
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
end
function c9911359.cffilter(c)
	return not c:IsPublic()
end
function c9911359.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9911359.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:GetClassCount(Card.GetCode)>=2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleDeck(tp)
		local p=tp
		local cg=Duel.GetMatchingGroup(c9911359.cffilter,tp,0,LOCATION_HAND,nil)
		if #cg>0 and Duel.SelectYesNo(1-tp,aux.Stringid(9911359,0)) then
			Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(9911359,1))
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CONFIRM)
			local tc=cg:Select(1-tp,1,1,nil):GetFirst()
			tc:RegisterFlagEffect(9911359,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,66)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_PUBLIC)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			p=1-tp
			Duel.AdjustAll()
			Duel.ShuffleHand(1-tp)
		end
		if p==1-tp then Duel.ConfirmCards(1-tp,sg) end
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_SPSUMMON)
		local tg=sg:Select(p,1,1,nil)
		Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
		sg:Sub(tg)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.RegisterFlagEffect(tp,9911360,RESET_PHASE+PHASE_END,0,1)
	end
end
function c9911359.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,9911360)==0
end
function c9911359.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsPreviousLocation(LOCATION_HAND+LOCATION_ONFIELD) and c:IsAbleToRemoveAsCost() end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function c9911359.thfilter(c)
	return c:IsSetCard(0xc956) and c:IsAbleToHand() and not c:IsCode(9911359)
end
function c9911359.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9911359.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9911359.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9911359.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
