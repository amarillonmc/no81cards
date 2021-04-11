--观星魔女·丝特拉
function c72411460.initial_effect(c)
	aux.AddCodeList(c,72411270)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),4,2)
	c:EnableReviveLimit()
		--search
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,72411460)
	e3:SetCost(c72411460.thcost)
	e3:SetTarget(c72411460.thtg)
	e3:SetOperation(c72411460.thop)
	c:RegisterEffect(e3)
end
function c72411460.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c72411460.cfilter(c)
	return c:IsFaceup() and c:IsCode(72411270)
end
function c72411460.thfilter(c,tp)
	return c:IsLevel(4) and c:IsRace(RACE_SPELLCASTER) and c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_FIRE+ATTRIBUTE_EARTH) and (c:IsAbleToGrave() or ( Duel.IsExistingMatchingCard(c72411460.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and c:IsAbleToHand() ) )
end
function c72411460.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c72411460.thfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c72411460.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c72411460.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.IsExistingMatchingCard(c72411460.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(72411460,0)) then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	elseif g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
