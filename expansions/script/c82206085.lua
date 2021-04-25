local m=82206085
local cm=_G["c"..m]
cm.name="暗之煞星"
function cm.initial_effect(c)
	--activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))  
	e1:SetCategory(CATEGORY_REMOVE)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)   
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetHintTiming(TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)  
	e1:SetTarget(cm.rmtg)  
	e1:SetOperation(cm.rmop) 
	c:RegisterEffect(e1) 
	--search  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,1))  
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)  
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e2:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)  
	e2:SetCondition(aux.exccon)
	e2:SetCost(cm.thcost)  
	e2:SetTarget(cm.thtg)  
	e2:SetOperation(cm.thop)  
	c:RegisterEffect(e2)  
end
function cm.desfilter(c,e,tp)  
	return c:IsFaceup() and c:IsSetCard(0x29c) and c:IsAbleToRemove() and 
	Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) and
	Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler())
end  
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:GetControler()==tp and cm.desfilter(chkc) end  
	if chk==0 then return Duel.IsExistingTarget(cm.desfilter,tp,LOCATION_ONFIELD,0,1,nil,e,tp) end  
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)  
	local g=Duel.SelectTarget(tp,cm.desfilter,tp,LOCATION_ONFIELD,0,1,1,nil,e,tp)  
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)  
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_ONFIELD)  
end  
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 then  
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)  
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())  
		if g:GetCount()>0 then  
			Duel.HintSelection(g)  
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)  
		end  
	end  
end  
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end  
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)  
end  
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3 end  
	Duel.SetTargetPlayer(tp)  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)  
end  
function cm.thfilter(c)  
	return c:IsSetCard(0x29c) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()  
end  
function cm.thop(e,tp,eg,ep,ev,re,r,rp)  
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)  
	Duel.ConfirmDecktop(p,3)  
	local g=Duel.GetDecktopGroup(p,3)  
	if g:GetCount()>0 and g:IsExists(cm.thfilter,1,nil) and Duel.SelectYesNo(p,aux.Stringid(m,1)) then  
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)  
		local sg=g:FilterSelect(p,cm.thfilter,1,1,nil)  
		Duel.SendtoHand(sg,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-p,sg)  
		Duel.ShuffleHand(p)  
	end  
	Duel.ShuffleDeck(p)  
end  