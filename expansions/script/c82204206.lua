local m=82204206
local cm=_G["c"..m]
cm.name="川尻早人"
function cm.initial_effect(c)
	aux.AddCodeList(c,82204200)
	--to deck
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,0))  
	e3:SetCategory(CATEGORY_TODECK)  
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)  
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e3:SetCountLimit(1,m)  
	e3:SetCondition(cm.tdcon)
	e3:SetTarget(cm.tdtg)  
	e3:SetOperation(cm.tdop)  
	c:RegisterEffect(e3)  
	--to hand
	local e4=Effect.CreateEffect(c)  
	e4:SetDescription(aux.Stringid(m,1))  
	e4:SetCategory(CATEGORY_TOHAND)  
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)  
	e4:SetCountLimit(1,82214206)  
	e4:SetCondition(cm.thcon)
	e4:SetCost(cm.thcost)
	e4:SetTarget(cm.thtg)  
	e4:SetOperation(cm.thop)  
	c:RegisterEffect(e4)  
end
function cm.tdcon(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0   
end  
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsAbleToDeck() end  
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)  
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,1,nil)  
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)  
end  
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) then  
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)  
	end  
end  
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()  
	if chk==0 then return c:IsReleasable() end  
	Duel.Release(c,REASON_COST)  
end  
function cm.filter(c)  
	return (c:IsCode(82204200) or aux.IsCodeListed(c,82204200)) and c:IsAbleToHand() and not c:IsCode(m) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end 
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_MAIN2  
end  
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)  
end  
function cm.thop(e,tp,eg,ep,ev,re,r,rp,chk)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.filter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,g)  
	end  
end  