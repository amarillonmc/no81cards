--数理罪论 证明你的学力
function c88887004.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,88887004+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c88887004.target)
	e1:SetOperation(c88887004.activate)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,18887004)
	e2:SetCondition(c88887004.tdcon)
	e2:SetTarget(c88887004.tdtg)
	e2:SetOperation(c88887004.tdop)
	c:RegisterEffect(e2)
end
function c88887004.thfilter(c,check)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
		and ((check and c:IsRace(RACE_SPELLCASTER) and c:IsAttribute(ATTRIBUTE_DARK+ATTRIBUTE_LIGHT)) or c:IsSetCard(0x881))
end
function c88887004.checkfilter(c)
	return c:IsType(TYPE_FUSION) and c:IsFaceup() and c:IsRace(RACE_SPELLCASTER) and c:IsLevel(12)
end
function c88887004.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local check=Duel.IsExistingMatchingCard(c88887004.checkfilter,tp,LOCATION_MZONE,0,1,nil)
		return Duel.IsExistingMatchingCard(c88887004.thfilter,tp,LOCATION_DECK,0,1,nil,check)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c88887004.activate(e,tp,eg,ep,ev,re,r,rp)
	local check=Duel.IsExistingMatchingCard(c88887004.checkfilter,tp,LOCATION_MZONE,0,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c88887004.thfilter,tp,LOCATION_DECK,0,1,1,nil,check)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c88887004.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEDOWN)
end
function c88887004.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsAbleToDeck() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c88887004.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
	end
end