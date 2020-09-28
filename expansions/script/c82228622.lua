local m=82228622
local cm=_G["c"..m]
cm.name="孑影之隐扉"
function cm.initial_effect(c)
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetCountLimit(1,m)  
	e1:SetTarget(cm.target)  
	e1:SetOperation(cm.activate)  
	c:RegisterEffect(e1)  
	--salvage  
	local e2=Effect.CreateEffect(c)  
	e2:SetCategory(CATEGORY_TOHAND)  
	e2:SetDescription(aux.Stringid(m,0))  
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetRange(LOCATION_GRAVE)  
	e2:SetCountLimit(1,m+10000)
	e2:SetCondition(aux.exccon)
	e2:SetCost(cm.thcost)  
	e2:SetTarget(cm.thtg)  
	e2:SetOperation(cm.thop)  
	c:RegisterEffect(e2)  
end
function cm.setfilter(c)  
	return c:IsSetCard(0x3299) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:IsSSetable() and not c:IsCode(m)
end  
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_DECK,0,1,nil) end  
end  
function cm.activate(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)  
	local g=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_DECK,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.SSet(tp,g:GetFirst())  
	end
end  
function cm.thfilter(c)  
	return c:IsSetCard(0x3299) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()  
end  
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_GRAVE,0,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)  
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)  
	Duel.Remove(g,POS_FACEUP,REASON_COST)  
end  
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsAbleToHand() end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)  
end  
function cm.thop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if c:IsRelateToEffect(e) then  
		Duel.SendtoHand(c,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,c)  
	end  
end  