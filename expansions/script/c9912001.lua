--天马行空
function c9912001.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c9912001.target)
	e1:SetOperation(c9912001.activate)
	c:RegisterEffect(e1)
end
function c9912001.filter(c)
	return (c:IsLocation(LOCATION_DECK) or c:IsFacedown()) and c:IsCode(15000211,11451001,9910051,65130301) and c:IsAbleToHand()
end
function c9912001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9912001.filter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_REMOVED)
end
function c9912001.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9912001.filter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil)
	local tc=g:GetFirst()
	if not tc or Duel.SendtoHand(tc,nil,REASON_EFFECT)==0 or not tc:IsLocation(LOCATION_HAND) then return end
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc)
	local sg=Group.CreateGroup()
	for i=1,2 do
		local cc=Duel.CreateToken(tp,tc:GetCode())
		sg:AddCard(cc)
	end
	Duel.SendtoDeck(sg,tp,SEQ_DECKSHUFFLE,REASON_RULE)
end
