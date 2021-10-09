--人类恶显现
function c9981592.initial_effect(c)
	--Activate
	local e1=aux.AddRitualProcGreater2(c,c9981592.filter,LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,9981592)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c9981592.thcon)
	e2:SetCost(c9981592.thcost)
	e2:SetTarget(c9981592.thtg)
	e2:SetOperation(c9981592.thop)
	c:RegisterEffect(e2)
end
function c9981592.filter(c)
	return c:IsSetCard(0x3ba8)
end
function c9981592.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c9981592.cfilter(c)
	return c:IsSetCard(0x3ba8) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c9981592.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c9981592.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c9981592.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c9981592.thfilter(c)
	return c:IsSetCard(0x3ba8) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c9981592.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9981592.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9981592.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9981592.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

