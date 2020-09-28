--暴风警报
function c9981092.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c9981092.target)
	e1:SetOperation(c9981092.activate)
	c:RegisterEffect(e1)
	--To hand
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,9981092)
	e4:SetCost(aux.bfgcost)
	e4:SetTarget(c9981092.thtg)
	e4:SetOperation(c9981092.thop)
	c:RegisterEffect(e4)
end
function c9981092.filter(c)
	return c:IsSetCard(0x10) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c9981092.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c9981092.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9981092.filter,tp,LOCATION_GRAVE,0,3,nil) 
		and ((Duel.IsPlayerCanDraw(tp) and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0)
		or Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil))
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c9981092.filter,tp,LOCATION_GRAVE,0,1,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c9981092.tgfilter(c,e)
	return not c:IsRelateToEffect(e)
end
function c9981092.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if g:IsExists(c9981092.tgfilter,1,nil,e) then return end
	Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
	Duel.ShuffleDeck(tp)
	Duel.BreakEffect()
	local op=0
	local b1=Duel.IsPlayerCanDraw(tp,1)
	local b2=Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,0)
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(9981092,1),aux.Stringid(9981092,2))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(9981092,1))
	elseif b2 then Duel.SelectOption(tp,aux.Stringid(9981092,2)) op=1
	else return end
	if op==0 then
		Duel.Draw(tp,1,REASON_EFFECT)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
		Duel.Destroy(dg,REASON_EFFECT)
	end
  Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981092,0))
end
function c9981092.thfilter(c)
	return c:IsSetCard(0x10) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9981092.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c9981092.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9981092.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c9981092.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c9981092.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981092,0))
end