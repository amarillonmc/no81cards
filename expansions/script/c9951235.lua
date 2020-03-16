--贝利亚雷击
function c9951235.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetTarget(c9951235.target)
	e1:SetOperation(c9951235.activate)
	c:RegisterEffect(e1)
 --to hand
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(9951235,0))
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(1,9951235)
	e5:SetCost(c9951235.thcost)
	e5:SetTarget(c9951235.thtg)
	e5:SetOperation(c9951235.thop)
	c:RegisterEffect(e5)
end
function c9951235.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x6bd2) and c:IsAbleToDeck()
end
function c9951235.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c9951235.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9951235.filter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,2,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c9951235.filter,tp,LOCATION_MZONE,0,1,1,nil)
	local dg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,e:GetHandler())
	dg:RemoveCard(g:GetFirst())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,dg:GetCount(),0,0)
end
function c9951235.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and c9951235.filter(tc)
		and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_DECK) then
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,aux.ExceptThisCard(e))
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c9951235.costfilter(c)
	return c:IsSetCard(0x9bd1) and c:IsDiscardable()
end
function c9951235.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,0)
		and Duel.IsExistingMatchingCard(c9951235.costfilter,tp,LOCATION_HAND,0,1,nil) end
	aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,1)
	Duel.DiscardHand(tp,c9951235.costfilter,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c9951235.thfilter(c)
	return c:IsSetCard(0x6bd2) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsCode(9951235) and c:IsAbleToHand()
end
function c9951235.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9951235.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9951235.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9951235.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

