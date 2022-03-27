function c60000011.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,60000011)
	e1:SetCost(c60000011.cost)
	e1:SetTarget(c60000011.target)
	e1:SetOperation(c60000011.operation)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetCondition(c60000011.condition)
	e3:SetTarget(c60000011.disable)
	e3:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e3)
end
function c60000011.cfilter(c,tp)
	return c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) and c:IsAbleToGraveAsCost()
end
function c60000011.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60000011.cfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c60000011.cfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	Duel.SendtoGrave(g,REASON_COST)
end
function c60000011.filter(c)
	return c:IsSetCard(0xcf) and c:IsLevelAbove(8) and c:IsAbleToHand()
end
function c60000011.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60000011.filter,tp,LOCATION_DECK,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c60000011.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c60000011.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end 
function c60000011.dfilter(c)
	return c:IsSetCard(0xcf) and c:IsLevelAbove(8)
end
function c60000011.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c60000011.dfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c60000011.disable(e,c)
	return (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0) and not c:IsAttribute(ATTRIBUTE_LIGHT) and not c:IsAttribute(ATTRIBUTE_DARK)
end