--异议复
local m=30005007
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,30005000)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)	
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	--Effect 2 
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(TIMING_END_PHASE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.tdcon)
	e2:SetTarget(cm.tdtg)
	e2:SetOperation(cm.tdop)
	c:RegisterEffect(e2)
end
--Effect 1
function cm.thfilter(c)
	if c:IsLocation(LOCATION_REMOVED) and c:IsFacedown() then return false end
	local sh=c:IsCode(30005000) or aux.IsCodeListed(c,30005000)
	return sh and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and cm.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,cm.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	if #g==0 then return end
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
end   
--Effect 2
function cm.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_END
end
function cm.tf(c)
	if c:IsLocation(LOCATION_REMOVED) and c:IsFacedown() then return false end
	local sh=c:IsCode(30005000) or aux.IsCodeListed(c,30005000)
	local rtc=c:IsType(TYPE_MONSTER) and (c:GetReason()&(REASON_RITUAL+REASON_MATERIAL)==(REASON_RITUAL+REASON_MATERIAL) and (c:GetReason()&REASON_RELEASE~=0 or c:IsLocation(LOCATION_REMOVED)))
	local rsp=c:GetType()==TYPE_RITUAL+TYPE_SPELL 
	return (sh or rtc or rsp) and c:IsAbleToDeck()
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and cm.tf(chkc) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(cm.tf,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,5,c) and c:IsAbleToDeck() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,cm.tf,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,5,5,c)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetTargetsRelateToChain()
	if #g==0 then return end
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	local tg=Duel.GetOperatedGroup()
	if tg:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=tg:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct==0 or not c:IsRelateToEffect(e) then return false end
	Duel.BreakEffect()
	Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end  