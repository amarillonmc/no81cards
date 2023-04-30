local m=82209006
local cm=_G["c"..m]
--伪毛绒动物·浣熊
function cm.initial_effect(c)
	--xyz summon  
	aux.AddXyzProcedure(c,cm.mfilter,4,2,cm.ovfilter,aux.Stringid(m,2),2,cm.xyzop)
	--search  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))  
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)  
	e1:SetType(EFFECT_TYPE_IGNITION)  
	e1:SetRange(LOCATION_MZONE)  
	e1:SetCountLimit(1,m)  
	e1:SetCost(cm.thcost)  
	e1:SetTarget(cm.thtg)  
	e1:SetOperation(cm.thop)  
	c:RegisterEffect(e1) 
	--tohand  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,1))  
	e2:SetCategory(CATEGORY_TOHAND)  
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)  
	e2:SetCode(EVENT_BE_MATERIAL)  
	e2:SetCountLimit(1,m+10000)  
	e2:SetCondition(cm.thcon2)  
	e2:SetTarget(cm.thtg2)  
	e2:SetOperation(cm.thop2)  
	c:RegisterEffect(e2)   
end
function cm.mfilter(c)  
	return c:IsRace(RACE_FAIRY) or c:IsRace(RACE_FIEND)
end  
function cm.ovfilter(c)  
	return c:IsFaceup() and c:IsSetCard(0xad) and c:GetSummonLocation()==LOCATION_EXTRA
end  
function cm.xyzop(e,tp,chk)  
	if chk==0 then return Duel.GetFlagEffect(tp,m)==0 end  
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)  
end  
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end  
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)  
end  
function cm.thfilter(c)  
	return c:IsSetCard(0xc3) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()  
end  
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)  
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,1,tp,1)  
end  
function cm.thop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)  
	if g:GetCount()==0 then return end  
	Duel.SendtoHand(g,nil,REASON_EFFECT)  
	Duel.ConfirmCards(1-tp,g)  
	Duel.ShuffleHand(tp)  
	Duel.BreakEffect()  
	Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT)  
end  
function cm.thcon2(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_FUSION  
end  
function cm.thfilter2(c)  
	return (c:IsCode(24094653) or (c:IsSetCard(0xad) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)))) and c:IsAbleToHand()  
end  
function cm.thtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.thfilter2(chkc) end  
	if chk==0 then return Duel.IsExistingTarget(cm.thfilter2,tp,LOCATION_GRAVE,0,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectTarget(tp,cm.thfilter2,tp,LOCATION_GRAVE,0,1,1,nil)  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)  
end  
function cm.thop2(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) then  
		Duel.SendtoHand(tc,nil,REASON_EFFECT)  
	end  
end  