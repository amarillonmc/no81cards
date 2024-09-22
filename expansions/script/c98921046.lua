--地球之外的窥视
function c98921046.initial_effect(c)
	aux.AddCodeList(c,64382839)
		--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DECKDES+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,98921046+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c98921046.target)
	e1:SetOperation(c98921046.activate)
	c:RegisterEffect(e1)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98921046,1))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c98921046.thtg)
	e3:SetOperation(c98921046.thop)
	c:RegisterEffect(e3)
end
function c98921046.tgfilter(c)
	return c:IsCode(64382839) and c:IsAbleToGrave()
end
function c98921046.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tp=e:GetHandlerPlayer()
	local b=Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,64382839)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and aux.NegateMonsterFilter(chkc) end
	local ct=1
	if b then ct=2 end
	if chk==0 then return Duel.IsExistingMatchingCard(c98921046.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) and Duel.IsExistingTarget(aux.NegateAnyFilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,ct,nil)
end
function c98921046.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local tp=e:GetHandlerPlayer()
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c98921046.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	if g1:GetCount()>0 then
		if Duel.SendtoGrave(g1,REASON_EFFECT)~=0 then
			local tc=g:GetFirst()
			while tc do
				  local e1=Effect.CreateEffect(c)
				  e1:SetType(EFFECT_TYPE_SINGLE)
				  e1:SetCode(EFFECT_DISABLE)
				  e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				  tc:RegisterEffect(e1)
				  local e2=Effect.CreateEffect(c)
				  e2:SetType(EFFECT_TYPE_SINGLE)
				  e2:SetCode(EFFECT_DISABLE_EFFECT)
				  e2:SetValue(RESET_TURN_SET)
				  e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				  tc:RegisterEffect(e2)
				  local e3=Effect.CreateEffect(c)
				  e3:SetType(EFFECT_TYPE_SINGLE)
				  e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				  e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
				  e3:SetValue(LOCATION_REMOVED)
				  e3:SetReset(RESET_EVENT+RESETS_REDIRECT)
				  tc:RegisterEffect(e3)
				  tc=g:GetNext()
		  end
	   end
	end
end
function c98921046.thfilter(c)
	return c:IsCode(64382839) and c:IsAbleToHand()
end
function c98921046.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98921046.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c98921046.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c98921046.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end