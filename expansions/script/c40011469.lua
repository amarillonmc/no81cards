--蒸汽淑女降临
function c40011469.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,40011469) 
	e1:SetTarget(c40011469.target)
	e1:SetOperation(c40011469.activate)
	c:RegisterEffect(e1) 
	--Remove 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCountLimit(1,10011469) 
	e2:SetCondition(c40011469.rmcon)
	e2:SetTarget(c40011469.rmtg)
	e2:SetOperation(c40011469.rmop)
	c:RegisterEffect(e2) 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_REMOVE)   
	e2:SetCondition(c40011469.xrmcon)
	e2:SetOperation(c40011469.xrmop)
	c:RegisterEffect(e2) 
end
function c40011469.filter(c)
	return c:IsSetCard(0xaf1a) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c40011469.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40011469.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c40011469.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c40011469.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c40011469.xrmcon(e,tp,eg,ep,ev,re,r,rp)
	if re==nil then return false end  
	local rc=re:GetHandler()
	return e:GetHandler():IsReason(REASON_COST) and re:IsActivated() and rc and rc:IsSetCard(0xaf1a) 
end 
function c40011469.xrmop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	c:RegisterFlagEffect(40011469,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1) 
end 
function c40011469.rmcon(e,tp,eg,ep,ev,re,r,rp) 
	return e:GetHandler():GetFlagEffect(40011469)~=0  
end 
function c40011469.rmfil(c) 
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemove() 
end 
function c40011469.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and c40011469.rmfil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c40011469.rmfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c40011469.rmfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c40011469.rmop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE) 
		e1:SetRange(LOCATION_REMOVED)
		e1:SetCountLimit(1)
		e1:SetOperation(function(e) 
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT) end) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end



