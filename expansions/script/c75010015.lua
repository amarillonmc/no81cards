--胆小的炭小侍
function c75010015.initial_effect(c)
	--deckdes
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCountLimit(1,75010015)
	e1:SetCost(c75010015.tgcost)
	e1:SetTarget(c75010015.tgtg)
	e1:SetOperation(c75010015.tgop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,75010016)
	e2:SetCondition(c75010015.thcon)
	e2:SetTarget(c75010015.thtg)
	e2:SetOperation(c75010015.thop)
	c:RegisterEffect(e2)
end
function c75010015.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c75010015.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,12) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,1)
end
function c75010015.seqfilter(c)
	return c:GetSequence()<6
end
function c75010015.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0):Filter(c75010015.seqfilter,nil)
	if #g<6 or g:FilterCount(Card.IsFacedown,nil)==0 then return end
	Duel.ConfirmCards(tp,g)
	local ct=g:FilterCount(Card.IsType,nil,TYPE_SPELL)
	Duel.DiscardDeck(tp,ct*2,REASON_EFFECT)
end
function c75010015.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function c75010015.thfilter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE)
		and (c:IsRace(RACE_ZOMBIE) and c:IsAbleToGrave() or c:IsRace(RACE_PSYCHO) and c:IsAbleToHand())
end
function c75010015.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75010015.thfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c75010015.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tc=Duel.SelectMatchingCard(tp,c75010015.thfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if not tc then return end
	local b1=tc:IsRace(RACE_PSYCHO) and tc:IsAbleToHand()
	local b2=tc:IsRace(RACE_ZOMBIE) and tc:IsAbleToGrave()
	if b1 and (not b2 or Duel.SelectOption(tp,1190,1191)==0) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	else
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
