--伊丽莎白演唱会仪式
function c9951179.initial_effect(c)
	 --Activate
	local e1=aux.AddRitualProcEqual2(c,c9951179.ffilter1,LOCATION_GRAVE+LOCATION_HAND,c9951179.ffilter2)
   --to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9951179,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c9951179.thtg)
	e2:SetOperation(c9951179.thop)
	c:RegisterEffect(e2)
end
function c9951179.ffilter1(c)
	return c:IsSetCard(0x9ba8)
end
function c9951179.ffilter2(c)
	return c:IsSetCard(0xba5)
end
function c9951179.thfilter(c)
	return c:IsCode(24094653) and c:IsAbleToHand()
end
function c9951179.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9951179.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c9951179.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9951179.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end