--女神聚会
function c9980209.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9980209)
	e1:SetTarget(c9980209.target)
	e1:SetOperation(c9980209.activate)
	c:RegisterEffect(e1)
	--activate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,9980209)
	e3:SetCost(c9980209.descost)
	e3:SetTarget(c9980209.target2)
	c:RegisterEffect(e3)
end
function c9980209.filter(c)
	return c:IsSetCard(0xbc8) and c:IsType(TYPE_NORMAL) and c:IsFaceup() and c:IsAbleToDeck()
end
function c9980209.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingMatchingCard(c9980209.filter,tp,LOCATION_EXTRA,0,1,nil)
		and Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler())
		and Duel.IsPlayerCanDraw(tp,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c9980209.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c9980209.filter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()==0 then return end
	Duel.ConfirmCards(1-tp,g)
	Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
	Duel.ShuffleDeck(tp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.BreakEffect()
		if Duel.Destroy(tc,REASON_EFFECT)==0 then return end
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c9980209.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c9980209.desfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xbc8)
end
function c9980209.thfilter(c)
	return c:IsSetCard(0xbc8) and c:IsType(TYPE_NORMAL) and (c:IsFaceup() or not c:IsLocation(LOCATION_EXTRA)) and c:IsAbleToHand()
end
function c9980209.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	local b1=Duel.IsExistingMatchingCard(c9980209.desfilter,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler())
	local b2=Duel.IsExistingMatchingCard(c9980209.thfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(9980209,0),aux.Stringid(9980209,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(9980209,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(9980209,1))+1
	end
	if op==0 then
		e:SetCategory(CATEGORY_DESTROY)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
		e:SetOperation(c9980209.desop)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	else
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		e:SetProperty(0)
		local g=Duel.GetMatchingGroup(c9980209.thfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil)
		e:SetOperation(c9980209.thop)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
	end
end
function c9980209.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then Duel.Destroy(tc,REASON_EFFECT) end
end
function c9980209.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9980209.thfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end