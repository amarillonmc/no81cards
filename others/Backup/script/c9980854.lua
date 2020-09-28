--魔法骑士·最后的希望
function c9980854.initial_effect(c)
	aux.AddRitualProcGreater2(c,c9980854.filter,LOCATION_HAND+LOCATION_GRAVE,c9980854.mfilter)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCondition(aux.exccon)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(c9980854.thtg)
	e1:SetOperation(c9980854.thop)
	c:RegisterEffect(e1)
end
function c9980854.filter(c)
	return c:IsSetCard(0x5bc2) and bit.band(c:GetType(),0x81)==0x81
end
function c9980854.mfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c9980854.thfilter(c)
	return c:IsSetCard(0x5bc2) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9980854.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9980854.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9980854.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9980854.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end