--黑狮子王的侍奉
function c9951607.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c9951607.cost)
	e1:SetTarget(c9951607.target)
	e1:SetOperation(c9951607.operation)
	c:RegisterEffect(e1)
end
function c9951607.costfilter(c)
	return c:IsSetCard(0x3ba6) and c:IsAbleToGraveAsCost()
end
function c9951607.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9951607.costfilter,tp,LOCATION_HAND,0,2,e:GetHandler()) end
	Duel.DiscardHand(tp,c9951607.costfilter,2,2,REASON_COST)
end
function c9951607.filter(c)
	return c:IsSetCard(0x46) and c:IsAbleToHand()
end
function c9951607.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9951607.filter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK)
end
function c9951607.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9951607.filter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

