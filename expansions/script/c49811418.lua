--星屑之转世
function c49811418.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,49811418)
	e1:SetTarget(c49811418.target)
	e1:SetOperation(c49811418.activate)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,49811419)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c49811418.thtg)
	e2:SetOperation(c49811418.thop)
	c:RegisterEffect(e2)
end
function c49811418.tdfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) and c:IsAbleToDeck() and c:IsFaceup()
end
function c49811418.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c49811418.tdfilter,tp,LOCATION_REMOVED,0,nil)
	local ct=g:GetClassCount(Card.GetAttribute)
	if chk==0 then return #g>0 and Duel.IsPlayerCanDraw(tp,ct) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,tp,LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c49811418.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetMatchingGroup(c49811418.tdfilter,tp,LOCATION_REMOVED,0,nil)
	if tg:GetCount()==0 then return end
	local ct=tg:GetClassCount(Card.GetAttribute)
	Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	local draw=Duel.Draw(tp,ct,REASON_EFFECT)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	if draw>0 and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(49811418,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=g:Select(tp,1,draw,nil)
		Duel.HintSelection(dg)
		Duel.Destroy(dg,REASON_EFFECT)
	end
end
function c49811418.thfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) and c:IsLevel(4,5,6) and c:IsAbleToHand()
end
function c49811418.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c49811418.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c49811418.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c49811418.thfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
