--柚子！
function c9951570.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9951570,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9951570+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c9951570.cost)
	e1:SetTarget(c9951570.target)
	e1:SetOperation(c9951570.activate)
	c:RegisterEffect(e1)
end
function c9951570.costfilter(c)
	return (c:IsAttribute(ATTRIBUTE_WIND) or c:IsRace(RACE_FAIRY)) and c:IsDiscardable()
end
function c9951570.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9951570.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c9951570.costfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c9951570.thfilter(c)
	return c:IsSetCard(0xf7,0x9b) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9951570.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c9951570.thfilter,tp,LOCATION_DECK,0,nil)
		return g:GetClassCount(Card.GetCode)>=2
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c9951570.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9951570.thfilter,tp,LOCATION_DECK,0,nil)
   if g:GetClassCount(Card.GetCode)>=2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g1=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1)
	end
end
