local m=82206055
local cm=_G["c"..m]
cm.name="植占术-血祭"
function cm.initial_effect(c)
	--Activate  
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOGRAVE)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)  
	e1:SetOperation(cm.activate)  
	c:RegisterEffect(e1)
	--to hand  
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))  
	e2:SetCategory(CATEGORY_TOHAND)  
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)  
	e2:SetCode(EVENT_RECOVER)  
	e2:SetProperty(EFFECT_FLAG_DELAY)  
	e2:SetRange(LOCATION_GRAVE)  
	e2:SetCountLimit(1,m)  
	e2:SetCondition(cm.thcon)  
	e2:SetTarget(cm.thtg)  
	e2:SetOperation(cm.thop)  
	c:RegisterEffect(e2)  
end   
function cm.filter(c)  
	return c:IsFaceup() and c:IsSetCard(0x29d)  
end  
function cm.condition(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) 
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsOnField() and chkc~=e:GetHandler() end  
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)  
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())  
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)  
	Duel.SetChainLimit(cm.chlimit)  
end  
function cm.chlimit(e,ep,tp)  
	return tp==ep  
end  
function cm.activate(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) then  
		Duel.SendtoGrave(tc,REASON_EFFECT)  
	end  
end  
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)  
	return ep==tp  
end  
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsAbleToHand() end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)  
end  
function cm.thop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if c:IsRelateToEffect(e) then  
		Duel.SendtoHand(c,nil,REASON_EFFECT)  
	end  
end