--欧布和捷德
function c9950746.initial_effect(c)
	aux.AddCodeList(c,9950282)
 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c9950746.target)
	e1:SetOperation(c9950746.activate)
	c:RegisterEffect(e1)
 --to hand
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(9950746,0))
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(1,9950746)
	e5:SetCost(c9950746.thcost)
	e5:SetTarget(c9950746.thtg)
	e5:SetOperation(c9950746.thop)
	c:RegisterEffect(e5)
end
function c9950746.filter(c)
	return (c:IsSetCard(0xcbd2) or aux.IsCodeListed(c,9950282)) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9950746.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9950746.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9950746.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9950746.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c9950746.costfilter(c)
	return c:IsSetCard(0x9bd1) and c:IsDiscardable()
end
function c9950746.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,0)
		and Duel.IsExistingMatchingCard(c9950746.costfilter,tp,LOCATION_HAND,0,1,nil) end
	aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,1)
	Duel.DiscardHand(tp,c9950746.costfilter,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c9950746.thfilter(c)
	return (c:IsSetCard(0x6bd2) or aux.IsCodeListed(c,9950282)) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsCode(9950746) and c:IsAbleToHand()
end
function c9950746.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9950746.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9950746.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9950746.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
