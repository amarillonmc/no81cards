--98374850
function c98374850.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,98374850+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c98374850.target)
	e1:SetOperation(c98374850.activate)
	c:RegisterEffect(e1)
end
function c98374850.thfilter(c)
	return c:IsSetCard(0x3af2) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c98374850.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(Card.IsSetCard,tp,LOCATION_PZONE,0,nil,0x3af2)
	local b1=ct==0 and Duel.IsExistingMatchingCard(nil,tp,LOCATION_HAND,0,1,e:GetHandler()) and Duel.IsExistingMatchingCard(c98374850.thfilter,tp,LOCATION_DECK,0,2,nil)
	local b2=ct==1 and Duel.IsExistingMatchingCard(c98374850.thfilter,tp,LOCATION_DECK,0,1,nil)
	local b3=ct==2 and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,nil)
	if chk==0 then return b1 or b2 or b3 end
end
function c98374850.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(c98374850.aclimit)
	Duel.RegisterEffect(e1,tp)
	local ct=Duel.GetMatchingGroupCount(Card.IsSetCard,tp,LOCATION_PZONE,0,nil,0x3af2)
	if ct==0 then
		if Duel.DiscardHand(tp,nil,1,1,REASON_DISCARD+REASON_EFFECT,nil)==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c98374850.thfilter,tp,LOCATION_DECK,0,2,2,nil)
		if g:GetCount()==2 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	elseif ct==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c98374850.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()==1 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	elseif ct==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,3,nil)
		if g:GetCount()==0 or Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)==0 then return end
		local og=Duel.GetOperatedGroup()
		local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_DECK)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCountLimit(1)
		e1:SetCondition(c98374850.thcon)
		e1:SetOperation(c98374850.thop)
		e1:SetLabel(ct)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c98374850.aclimit(e,re,tp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and not rc:IsSetCard(0x3af2) and rc:IsLocation(LOCATION_MZONE)
end
function c98374850.thfilter2(c)
	return c:GetType()==TYPE_TRAP and c:IsAbleToHand()
end
function c98374850.thcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c98374850.thfilter2,tp,LOCATION_DECK,0,nil)
	return g:GetClassCount(Card.GetCode)>=e:GetLabel()
end
function c98374850.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c98374850.thfilter2,tp,LOCATION_DECK,0,nil)
	local ct=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=g:SelectSubGroup(tp,aux.dncheck,false,ct,ct)
	Duel.SendtoHand(tg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tg)
end
