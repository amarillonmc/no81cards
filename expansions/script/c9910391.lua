--虹彩偶像的约定
function c9910391.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9910391+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9910391.target)
	e1:SetOperation(c9910391.activate)
	c:RegisterEffect(e1)
end
function c9910391.tdfilter(c,tp)
	return not c:IsPublic() and c:IsAbleToDeck() and c:IsSetCard(0x5951) and c:IsType(TYPE_MONSTER)
		and Duel.IsExistingMatchingCard(c9910391.filter1,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function c9910391.filter1(c,code)
	return c:IsSetCard(0x5951) and aux.IsCodeListed(c,code) and c:IsType(TYPE_FIELD) and c:IsAbleToHand()
end
function c9910391.filter2(c)
	return c:IsSetCard(0x5951) and c:IsLevel(1) and c:IsAbleToHand()
end
function c9910391.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910391.filter2,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(c9910391.tdfilter,tp,LOCATION_HAND,0,1,e:GetHandler(),tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c9910391.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c9910391.tdfilter,tp,LOCATION_HAND,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if not tc then return end
	Duel.ConfirmCards(1-tp,tc)
	local g1=Duel.GetMatchingGroup(c9910391.filter1,tp,LOCATION_DECK,0,nil,tc:GetCode())
	local g2=Duel.GetMatchingGroup(c9910391.filter2,tp,LOCATION_DECK,0,nil)
	if g1:GetCount()>0 and g2:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg2=g2:Select(tp,1,1,nil)
		sg1:Merge(sg2)
		Duel.SendtoHand(sg1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg1)
		Duel.BreakEffect()
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	else
		Duel.ShuffleHand(tp)
	end
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) and e:IsHasType(EFFECT_TYPE_ACTIVATE)
		and not Duel.IsExistingMatchingCard(Card.IsSummonLocation,tp,LOCATION_MZONE,0,1,nil,LOCATION_EXTRA)
		and Duel.IsExistingMatchingCard(Card.IsSummonLocation,tp,0,LOCATION_MZONE,1,nil,LOCATION_EXTRA) then
		c:CancelToGrave()
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(9910391,0))
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EVENT_CHAIN_SOLVING)
		e1:SetRange(LOCATION_SZONE)
		e1:SetCondition(c9910391.thcon)
		e1:SetOperation(c9910391.thop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end
function c9910391.thfilter(c)
	return c:IsAbleToHand() and Duel.IsExistingMatchingCard(Card.IsAbleToHand,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)
end
function c9910391.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return c:GetFlagEffect(9910391)==0 and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and g and g:IsContains(c)
		and Duel.IsExistingMatchingCard(c9910391.thfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c9910391.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SelectEffectYesNo(tp,c,aux.Stringid(9910391,1)) then
		Duel.Hint(HINT_CARD,0,9910391)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g1=Duel.SelectMatchingCard(tp,c9910391.thfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g2=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,g1)
		g1:Merge(g2)
		Duel.HintSelection(g1)
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
		c:RegisterFlagEffect(9910391,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9910391,2))
	end
end
