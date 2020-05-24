--爱、不在此处
function c9950693.initial_effect(c)
	 --discard deck
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_DECKDES)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTarget(c9950693.distarget)
	e1:SetOperation(c9950693.disop)
	c:RegisterEffect(e1)
--To hand
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCost(aux.bfgcost)
	e4:SetTarget(c9950693.thtg)
	e4:SetOperation(c9950693.thop)
	c:RegisterEffect(e4)
end
function c9950693.distarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,0,0,PLAYER_ALL,5)
end
function c9950693.disop(e,tp,eg,ep,ev,re,r,rp)
	 Duel.DiscardDeck(tp,5,REASON_EFFECT)
	Duel.DiscardDeck(1-tp,5,REASON_EFFECT)
end
function c9950693.thfilter(c)
	return c:IsSetCard(0xcba8) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9950693.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c9950693.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9950693.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c9950693.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c9950693.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
