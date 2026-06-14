--帝王君临
function c11182310.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,11182310)
	e1:SetCost(c11182310.DisCardCost)
	e1:SetTarget(c11182310.thtg)
	e1:SetOperation(c11182310.thop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DISCARD)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,11182310+1)
	e2:SetTarget(c11182310.tgtg)
	e2:SetOperation(c11182310.tgop)
	c:RegisterEffect(e2)
end
function c11182310.tgfilter(c)
	return c:IsSetCard(0x6454) and (c:IsAbleToGrave() or c:IsAbleToRemove())
end
function c11182310.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11182310.tgfilter,tp,LOCATION_DECK,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c11182310.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c11182310.tgfilter,tp,LOCATION_DECK,0,2,2,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if tc and tc:IsAbleToGrave() and (not tc:IsAbleToRemove() or Duel.SelectOption(tp,1191,1192)==0) then
			Duel.SendtoGrave(tc,REASON_EFFECT)
		else
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function c11182310.thfilter(c)
	return c:IsSetCard(0x6454) and c:IsAbleToHand()
end
function c11182310.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11182310.thfilter,tp,LOCATION_DECK,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c11182310.thop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c11182310.thfilter,tp,LOCATION_DECK,0,2,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c11182310.thfilter,tp,LOCATION_DECK,0,2,2,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g)
		if Duel.SelectYesNo(tp,aux.Stringid(11182310,0)) then
			Duel.BreakEffect()
			Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
		end
	end
end
function c11182310.DisCardCostFilter(c,tp)
	return c:IsAbleToDeckAsCost() and c:IsHasEffect(11182305,tp)
end
function c11182310.DisCardCost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,nil)
	local g2=Duel.GetMatchingGroup(c11182310.DisCardCostFilter,tp,0x30,0,nil,tp)
	g1:Merge(g2)
	if chk==0 then return g1:GetCount()>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local tc=g1:Select(tp,1,1,nil):GetFirst()
	local te=tc:IsHasEffect(11182305,tp)
	if te then
		te:UseCountLimit(tp)
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT+REASON_REPLACE)
	else
		Duel.SendtoGrave(tc,REASON_COST+REASON_DISCARD)
	end
end