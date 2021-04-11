--炎星杰-蛇林
function c19198145.initial_effect(c)
--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(19198145,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,19198145)
	e2:SetCost(c19198145.thcost)
	e2:SetTarget(c19198145.thtg)
	e2:SetOperation(c19198145.thop)
	c:RegisterEffect(e2)	
end
function c19198145.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c19198145.thfilter(c)
	return c:IsSetCard(0x79) and not c:IsCode(19198145) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c19198145.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c19198145.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c19198145.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c19198145.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end