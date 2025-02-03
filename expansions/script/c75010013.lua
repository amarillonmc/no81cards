--勇敢的炭小侍
function c75010013.initial_effect(c)
	--deckdes
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCountLimit(1,75010013)
	e1:SetCost(c75010013.tgcost)
	e1:SetTarget(c75010013.tgtg)
	e1:SetOperation(c75010013.tgop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,75010014)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c75010013.thtg)
	e2:SetOperation(c75010013.thop)
	c:RegisterEffect(e2)
end
function c75010013.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c75010013.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,12) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,1)
end
function c75010013.seqfilter(c)
	return c:GetSequence()<6
end
function c75010013.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0):Filter(c75010013.seqfilter,nil)
	if #g<6 or g:FilterCount(Card.IsFacedown,nil)==0 then return end
	Duel.ConfirmCards(tp,g)
	local ct=g:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_FIRE)
	Duel.DiscardDeck(tp,ct*2,REASON_EFFECT)
end
function c75010013.thfilter(c)
	return bit.band(c:GetType(),TYPE_RITUAL+TYPE_SPELL)==TYPE_RITUAL+TYPE_SPELL and c:IsAbleToHand()
end
function c75010013.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c75010013.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c75010013.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c75010013.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c75010013.sfilter(c,tc)
	return bit.band(c:GetType(),TYPE_RITUAL+TYPE_MONSTER)==TYPE_RITUAL+TYPE_MONSTER and c:IsAbleToHand() and aux.IsCodeListed(tc,c:GetCode()) and aux.NecroValleyFilter()(c)
end
function c75010013.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(tp,tc)
		if Duel.IsExistingMatchingCard(c75010013.sfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tc) and Duel.SelectYesNo(tp,aux.Stringid(75010013,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,c75010013.sfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tc)
			if #g>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end
	end
end
