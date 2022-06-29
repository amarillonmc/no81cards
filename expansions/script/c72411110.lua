--马纳历亚的睿智
--马纳历亚的睿智
function c72411110.initial_effect(c)
	aux.AddCodeList(c,72411020,72411030)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c72411110.target)
	e1:SetOperation(c72411110.activate)
	c:RegisterEffect(e1)
end
--MODAN 
function c72411110.filtera(c)
	return c:IsCode(72411020) and c:IsAbleToHand()
end
function c72411110.filterb(c)
	return c:IsCode(72411030) and c:IsAbleToHand()
end
function c72411110.filterc(c,tp)
	return (c:IsSetCard(0x5729) or (Duel.IsPlayerAffectedByEffect(tp,72413440) and c:GetType()==TYPE_SPELL)) and c:IsAbleToDeck()
end
function c72411110.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c72411110.filtera,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c72411110.filterb,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c72411110.filterc,tp,LOCATION_HAND,0,1,e:GetHandler(),tp) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c72411110.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetMatchingGroup(c72411110.filterc,p,LOCATION_HAND,0,nil,tp)
	if g:GetCount()>=1 then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
		local sg=g:Select(p,1,1,nil)
		Duel.ConfirmCards(1-p,sg)
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
		Duel.ShuffleDeck(p)
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,c72411110.filtera,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
			end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,c72411110.filterb,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
