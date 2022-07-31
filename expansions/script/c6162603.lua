--轮回世界 但他林
function c6162603.initial_effect(c)
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_DISABLE)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e1:SetCode(EVENT_FREE_CHAIN)	
	e1:SetTarget(c6162603.target)  
	e1:SetOperation(c6162603.operation)  
	c:RegisterEffect(e1)
	--search  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(24010609,1))  
	e2:SetCategory(CATEGORY_LEAVE_GRAVE)  
	e2:SetType(EFFECT_TYPE_QUICK_O)  
	e2:SetCode(EVENT_FREE_CHAIN)  
	e2:SetRange(LOCATION_GRAVE)  
	e2:SetCountLimit(1,6162603)  
	e2:SetCondition(aux.exccon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c6162603.thtg)  
	e2:SetOperation(c6162603.thop)  
	c:RegisterEffect(e2)  
end
function c6162603.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsOnField() and aux.disfilter1(chkc) end  
	if chk==0 then return Duel.IsExistingTarget(aux.disfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)  
	local g=Duel.SelectTarget(tp,aux.disfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)  
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)  
end  
function c6162603.operation(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local tc=Duel.GetFirstTarget()  
	if ((tc:IsFaceup() and not tc:IsDisabled()) or tc:IsType(TYPE_TRAPMONSTER)) and tc:IsRelateToEffect(e) then  
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)  
		local e1=Effect.CreateEffect(c)  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
		e1:SetCode(EFFECT_DISABLE)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)  
		tc:RegisterEffect(e1)  
		local e2=Effect.CreateEffect(c)  
		e2:SetType(EFFECT_TYPE_SINGLE)  
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
		e2:SetCode(EFFECT_DISABLE_EFFECT)  
		e2:SetValue(RESET_TURN_SET)  
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)  
		tc:RegisterEffect(e2)  
		if tc:IsType(TYPE_TRAPMONSTER) then  
			local e3=Effect.CreateEffect(c)  
			e3:SetType(EFFECT_TYPE_SINGLE)  
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)  
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)  
			tc:RegisterEffect(e3)  
		end  
	end  
end  
function c6162603.thfilter(c)  
	return c:IsOriginalSetCard(0x616,0x626) and c:IsType(TYPE_TRAP) and not c:IsCode(6162603)
end  
function c6162603.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c6162603.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c6162603.thop(e,tp,eg,ep,ev,te,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c6162603.thfilter,tp,LOCATION_DECK,0,1,1,nil) 
	if g:GetCount()>0 then
		 Duel.SendtoHand(g,nil,REASON_EFFECT)
		 Duel.ConfirmCards(1-tp,g)
	end
end