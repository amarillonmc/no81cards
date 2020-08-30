local m=82228601
local cm=_G["c"..m]
cm.name="荒兽 丘"
function cm.initial_effect(c)
	--banish extra  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,1))  
	e1:SetCategory(CATEGORY_REMOVE)  
	e1:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_IGNITION)  
	e1:SetCountLimit(1)  
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCondition(cm.con)
	e1:SetCost(cm.cost)  
	e1:SetTarget(cm.extg)  
	e1:SetOperation(cm.exop)  
	c:RegisterEffect(e1)  
	--register to grave  
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)  
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
	e3:SetCode(EVENT_TO_GRAVE)  
	e3:SetOperation(cm.regop)  
	c:RegisterEffect(e3)  
	--search  
	local e4=Effect.CreateEffect(c)  
	e4:SetDescription(aux.Stringid(m,0))  
	e4:SetCategory(CATEGORY_TOHAND)  
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)  
	e4:SetCode(EVENT_PHASE+PHASE_END)  
	e4:SetCountLimit(1,m)  
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e4:SetRange(LOCATION_GRAVE)  
	e4:SetCondition(cm.thcon)  
	e4:SetTarget(cm.thtg)  
	e4:SetOperation(cm.thop)  
	c:RegisterEffect(e4)  
end  
function cm.con(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():IsSetCard(0x2299)  
end  
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end 
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription()) 
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)  
end  
function cm.extg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_EXTRA)  
end  
function cm.exop(e,tp,eg,ep,ev,re,r,rp)  
	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)  
	Duel.ConfirmCards(tp,g)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)  
	local sg=g:FilterSelect(tp,Card.IsAbleToRemove,1,1,nil)  
	Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)  
end  
function cm.regop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)  
end  
function cm.thfilter(c)  
	return c:IsSetCard(0x2299) and not c:IsCode(m) and c:IsAbleToHand()  
end  
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():GetFlagEffect(m)>0  
end  
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and cm.thfilter(chkc) end  
	if chk==0 then return Duel.IsExistingTarget(cm.thfilter,tp,LOCATION_GRAVE,0,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectTarget(tp,cm.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,LOCATION_GRAVE)  
end  
function cm.thop(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) then  
		Duel.SendtoHand(tc,nil,REASON_EFFECT)  
	end  
end  
