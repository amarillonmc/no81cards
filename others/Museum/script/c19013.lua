--铭兽 魔王的使徒
function c19013.initial_effect(c)
		--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(19013,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,19013)
	e1:SetCost(c19013.cost)
	e1:SetTarget(c19013.target)
	e1:SetOperation(c19013.operation)
	c:RegisterEffect(e1)
end
	function c19013.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
	function c19013.filter(c)
	return c:IsSetCard(0x890) and c:IsAbleToHand() and c:IsType(TYPE_RITUAL+TYPE_MONSTER)
end
	function c19013.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c19013.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
	function c19013.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c19013.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end