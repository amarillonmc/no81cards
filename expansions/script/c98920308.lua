--闪刀姬-力纳
function c98920308.initial_effect(c)
	c:SetSPSummonOnce(98920308)
	 --xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x1115),4,2,c98920308.ovfilter,aux.Stringid(98920308,1))
	--attack up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920308,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c98920308.cost)
	e1:SetTarget(c98920308.target)
	e1:SetOperation(c98920308.operation)
	c:RegisterEffect(e1)
	--effect gain
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(c98920308.effcon)
	e3:SetOperation(c98920308.effop)
	c:RegisterEffect(e3)
end
function c98920308.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x115) and c:IsType(TYPE_LINK) and c:IsAttribute(ATTRIBUTE_EARTH)
end
function c98920308.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c98920308.cfilter(c)
	return c:IsSetCard(0x115)
end
function c98920308.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,3)
		and Duel.GetDecktopGroup(tp,3):FilterCount(Card.IsAbleToHand,nil)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c98920308.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerCanDiscardDeck(tp,3) then
		Duel.ConfirmDecktop(tp,3)
		local g=Duel.GetDecktopGroup(tp,3)
		if g:GetCount()>0 then
			if g:IsExists(c98920308.cfilter,1,nil) then
				Duel.DisableShuffleCheck()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sg=g:FilterSelect(tp,c98920308.cfilter,1,1,nil)
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
				Duel.ShuffleHand(tp)
				g:Sub(sg)
				Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
			else
				Duel.ShuffleDeck(tp)
			end
		end
	end
end
function c98920308.effcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_LINK and e:GetHandler():GetReasonCard():IsSetCard(0x1115)
end
function c98920308.effop(e,tp,eg,ep,ev,re,r,rp)
	 local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920308,1))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetValue(1)
	e1:SetOwnerPlayer(ep)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
end