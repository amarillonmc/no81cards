--众神遗留的爱
function c9950269.initial_effect(c)
	aux.AddRitualProcEqual2(c,c9950269.filter,LOCATION_DECK+LOCATION_HAND,c9950269.mfilter)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCondition(aux.exccon)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(c9950269.thtg)
	e1:SetOperation(c9950269.thop)
	c:RegisterEffect(e1)
end
c9950269.card_code_list={9950260,9950262}
function c9950269.filter(c,e,tp,m1,m2,ft)
	return c:IsSetCard(0xba5,0xbc8) and c:IsType(TYPE_RITUAL)
end
function c9950269.mfilter(c)
	return c:IsCode(9950260,9950262)
end
function c9950269.thfilter(c)
	return c:IsSetCard(0xba5,0xbc8) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c9950269.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9950269.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9950269.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9950269.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end