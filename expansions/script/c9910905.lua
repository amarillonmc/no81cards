--魔导驭傀师 幻视
function c9910905.initial_effect(c)
	aux.AddCodeList(c,9910871)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,9910905)
	e1:SetCost(c9910905.thcost)
	e1:SetTarget(c9910905.thtg)
	e1:SetOperation(c9910905.thop)
	c:RegisterEffect(e1)
end
function c9910905.costfilter(c)
	return aux.IsCodeListed(c,9910871) and c:IsAbleToRemoveAsCost()
end
function c9910905.cfilter(c)
	return c:IsCode(9910871) or c:IsRace(RACE_SPELLCASTER)
end
function c9910905.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c9910905.costfilter,tp,LOCATION_GRAVE,0,1,c) and c:IsAbleToRemoveAsCost() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c9910905.costfilter,tp,LOCATION_GRAVE,0,1,1,c)
	g:AddCard(c)
	local label=0
	if g:IsExists(c9910905.cfilter,1,nil) then label=1 end
	e:SetLabel(label)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c9910905.thfilter(c)
	return aux.IsCodeListed(c,9910871) and c:IsAbleToHand()
end
function c9910905.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local dg=Duel.GetMatchingGroup(c9910905.thfilter,tp,LOCATION_DECK,0,nil)
		return dg:GetClassCount(Card.GetCode)>=3
	end
	local ct=1
	if e:GetLabel()==1 then ct=2 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,ct,tp,LOCATION_DECK)
end
function c9910905.thop(e,tp,eg,ep,ev,re,r,rp)
	local ct=1
	if e:GetLabel()==1 then ct=2 end
	local g=Duel.GetMatchingGroup(c9910905.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)>=3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg1=g:SelectSubGroup(tp,aux.dncheck,false,3,3)
		Duel.ConfirmCards(1-tp,sg1)
		Duel.ShuffleDeck(tp)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
		local cg=sg1:Select(1-tp,ct,ct,nil)
		for tc in aux.Next(cg) do
			tc:SetStatus(STATUS_TO_HAND_WITHOUT_CONFIRM,true)
		end
		Duel.SendtoHand(cg,nil,REASON_EFFECT)
		sg1:Sub(cg)
		Duel.SendtoGrave(sg1,REASON_EFFECT)
	end
end
