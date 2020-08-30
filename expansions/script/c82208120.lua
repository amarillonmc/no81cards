local m=82208120
local cm=_G["c"..m]
cm.name="龙法师 邪灵巫师"
function cm.initial_effect(c)
	--search itself  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))  
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)  
	e1:SetType(EFFECT_TYPE_QUICK_O)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetHintTiming(TIMING_END_PHASE)  
	e1:SetRange(LOCATION_HAND)  
	e1:SetCountLimit(1,m)  
	e1:SetCost(cm.cost)  
	e1:SetTarget(cm.target)  
	e1:SetOperation(cm.operation)  
	c:RegisterEffect(e1)  
	--protect
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,1)) 
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMING_DRAW)
	e2:SetRange(LOCATION_GRAVE)  
	e2:SetCost(cm.thcost)  
	e2:SetOperation(cm.thop)  
	c:RegisterEffect(e2)  
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsDiscardable() and Duel.GetFieldGroupCount(tp,0x01,0)>7 and Duel.IsPlayerCanDiscardDeckAsCost(tp,7) end  
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)  
	Duel.DiscardDeck(tp,7,REASON_COST)  
end  
function cm.filter(c)  
	return c:IsSetCard(0x6299) and not c:IsCode(m) and c:IsAbleToHand()  
end  
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)  
end  
function cm.operation(e,tp,eg,ep,ev,re,r,rp,chk)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,g)  
	end  
end  
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end  
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)  
end  
function cm.thop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local e4=Effect.CreateEffect(c)  
	e4:SetType(EFFECT_TYPE_FIELD)  
	e4:SetCode(EFFECT_CANNOT_INACTIVATE) 
	e4:SetValue(cm.effectfilter)  
	e4:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e4,tp)  
	local e5=Effect.CreateEffect(c)  
	e5:SetType(EFFECT_TYPE_FIELD)  
	e5:SetCode(EFFECT_CANNOT_DISEFFECT) 
	e5:SetValue(cm.effectfilter)  
	e5:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e5,tp)  
end
function cm.effectfilter(e,ct)  
	local p=e:GetHandler():GetControler()  
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)  
	return p==tp and te:GetHandler():IsSetCard(0x6299)
end  