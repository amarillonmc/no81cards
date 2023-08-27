--炽金战兽之牙
local m=82209165
local cm=c82209165
function cm.initial_effect(c)
	--Activate  
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_CHAINING)  
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.accon)
	e1:SetTarget(cm.actg)  
	e1:SetOperation(cm.acop)  
	c:RegisterEffect(e1)  
	--to hand  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,0))  
	e2:SetCategory(CATEGORY_TOHAND)  
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_GRAVE)  
	e2:SetCountLimit(1,m)  
	e2:SetCost(aux.bfgcost)  
	e2:SetTarget(cm.thtg)  
	e2:SetOperation(cm.thop)  
	c:RegisterEffect(e2) 
end  

--activate
function cm.cfilter(c)  
	return c:IsFaceup() and c:IsSetCard(0x5294) 
end  
function cm.accon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and rp==1-tp and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil) 
end
function cm.tgfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsAbleToGrave()
end
function cm.actg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function cm.acop(e,tp,eg,ep,ev,re,r,rp)  
	local g=Group.CreateGroup()  
	Duel.ChangeTargetCard(ev,g)  
	Duel.ChangeChainOperation(ev,cm.repop)  
end  
function cm.repop(e,tp,eg,ep,ev,re,r,rp)  
	local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,0,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end  

--to hand
function cm.thfilter(c)  
	return c:IsSetCard(0x5294) and c:IsAbleToHand() and not c:IsCode(m)
end  
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.thfilter(chkc) and chkc~=c end  
	if chk==0 then return Duel.IsExistingTarget(cm.thfilter,tp,LOCATION_GRAVE,0,1,c) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,cm.thfilter,tp,LOCATION_GRAVE,0,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)  
end  
function cm.thop(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end  