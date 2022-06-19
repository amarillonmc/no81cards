--恶性复活
function c9910911.initial_effect(c)
	aux.AddCodeList(c,9910871,9910909)
	aux.AddRitualProcGreater2(c,c9910911.filter,LOCATION_HAND+LOCATION_EXTRA,c9910911.mfilter)
	--salvage
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCost(c9910911.thcost)
	e1:SetTarget(c9910911.thtg)
	e1:SetOperation(c9910911.thop)
	c:RegisterEffect(e1)
end
function c9910911.filter(c)
	return c:IsCode(9910909) and (not c:IsLocation(LOCATION_EXTRA) or c:IsFaceup())
end
function c9910911.mfilter(c)
	return aux.IsCodeListed(c,9910871)
end
function c9910911.thfilter(c)
	return c:IsCode(9910871) and c:IsAbleToRemoveAsCost()
end
function c9910911.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910911.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c9910911.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c9910911.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c9910911.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
