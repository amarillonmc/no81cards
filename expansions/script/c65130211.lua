--重要的回忆
function c65130211.initial_effect(c)
	aux.AddCodeList(c,65130201)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65130211,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65130211+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c65130211.thcost)
	e1:SetTarget(c65130211.thtg)
	e1:SetOperation(c65130211.thop)
	c:RegisterEffect(e1)
end
function c65130211.costfilter(c)
	return c:IsCode(65130201) and c:IsAbleToGraveAsCost()
end
function c65130211.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65130211.costfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c65130211.costfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c65130211.thfilter(c)
	return aux.IsCodeListed(c,65130201) and c:IsAbleToHand()
end
function c65130211.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65130211.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c65130211.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c65130211.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end