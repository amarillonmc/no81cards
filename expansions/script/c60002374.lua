--阿不思的天启
local cm,m,o=GetID()
function cm.initial_effect(c)
	--change name
	aux.EnableChangeCode(c,68468459,LOCATION_MZONE+LOCATION_GRAVE)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.drtg)
	e2:SetOperation(cm.drop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,m+10000000)
	e3:SetCondition(cm.thcon)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_COST) and re:IsActivated()
end
function cm.thfilter(c)
	return c:IsSetCard(0x15d) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.tdfilter(c)
	return c:IsType(TYPE_FUSION) and c:IsAbleToDeck()
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and cm.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,3,nil) and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,68468459) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK) 
	local g=Duel.SelectTarget(tp,cm.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()<=0 then return end
	local b1=false
	local b2=false
	if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,68468459) then b1=true end
	if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,68468459) then b2=true end
	local op=aux.SelectFromOptions(tp,
	{b1,aux.Stringid(m,0)},
	{b2,aux.Stringid(m,1)})
	if op==1 then
		local g=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_DECK,0,nil,68468459)
		Duel.SendtoGrave(g,REASON_EFFECT)
	elseif op==2 then
		local g=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,68468459)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end

