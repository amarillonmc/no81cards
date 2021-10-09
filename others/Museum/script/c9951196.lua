--崩坏·天使重构
function c9951196.initial_effect(c)
	 aux.AddRitualProcGreaterCode(c,9951197,LOCATION_GRAVE+LOCATION_HAND+LOCATION_DECK,nil)
 --salvage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9951196,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCost(c9951196.cost)
	e1:SetTarget(c9951196.tg)
	e1:SetOperation(c9951196.op)
	c:RegisterEffect(e1)
end
function c9951196.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c9951196.thfilter(c)
	return bit.band(c:GetType(),0x81)==0x81 and c:IsAbleToHand()
end
function c9951196.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
   if chk==0 then return Duel.IsExistingMatchingCard(c9951196.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9951196.op(e,tp,eg,ep,ev,re,r,rp)
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9951196.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
