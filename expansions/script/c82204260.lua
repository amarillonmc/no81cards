local m=82204260
local cm=_G["c"..m]
cm.name="捕兽夹"
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m)  
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	c:RegisterEffect(e1)   
	--damage  
	local e4=Effect.CreateEffect(c)  
	e4:SetDescription(aux.Stringid(m,0))  
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
	e4:SetRange(LOCATION_SZONE)  
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)  
	e4:SetCondition(cm.atkcon) 
	e4:SetOperation(cm.atkop)  
	c:RegisterEffect(e4) 
	--to grave  
	local e0=Effect.CreateEffect(c)  
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)  
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
	e0:SetCode(EVENT_TO_GRAVE)  
	e0:SetOperation(cm.regop)  
	c:RegisterEffect(e0)  
	--search  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,1))  
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)  
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)  
	e2:SetCode(EVENT_PHASE+PHASE_END)  
	e2:SetCountLimit(1,m)  
	e2:SetRange(LOCATION_GRAVE)  
	e2:SetCondition(cm.thcon)  
	e2:SetTarget(cm.thtg)  
	e2:SetOperation(cm.thop)  
	c:RegisterEffect(e2)  
end
cm.SetCard_01_RedHat=true 
function cm.isRedHat(c)
	local code=c:GetCode()
	local ccode=_G["c"..code]
	return ccode.SetCard_01_RedHat
end
function cm.cfilter(c)  
	return c:IsFaceup() and cm.isRedHat(c)
end  
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.GetAttacker():GetControler()~=tp and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)
end  
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_CARD,0,m) 
	Duel.Damage(1-tp,Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)*500,REASON_EFFECT)  
end  
function cm.regop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)  
end  
function cm.thfilter(c)  
	return c:IsCode(82204253) and c:IsAbleToHand()  
end  
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():GetFlagEffect(m)>0  
end  
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)  
end  
function cm.thop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,g)  
	end  
end  