--风之联合
function c9951569.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9951569,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9951569+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c9951569.cost)
	e1:SetTarget(c9951569.target)
	e1:SetOperation(c9951569.activate)
	c:RegisterEffect(e1)
end
function c9951569.costfilter(c)
	return (c:IsAttribute(ATTRIBUTE_WIND) or c:IsRace(RACE_BEASTWARRIOR)) and c:IsDiscardable()
end
function c9951569.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9951569.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c9951569.costfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c9951569.thfilter(c)
	return c:IsSetCard(0xf0,0xdf) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9951569.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c9951569.thfilter,tp,LOCATION_DECK,0,nil)
		return g:GetClassCount(Card.GetCode)>=2
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c9951569.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9951569.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)>=2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g1=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1)
	end
end