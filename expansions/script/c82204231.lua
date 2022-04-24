local m=82204231
local cm=_G["c"..m]
cm.name="孤独的时之行者"
function cm.initial_effect(c)
	--search itself  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))  
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)  
	e1:SetType(EFFECT_TYPE_IGNITION)  
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)  
	e1:SetCountLimit(2,m)  
	e1:SetCost(cm.cost)  
	e1:SetTarget(cm.target1)  
	e1:SetOperation(cm.operation1)  
	c:RegisterEffect(e1)  
	--lock
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,1))	
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND+LOCATION_MZONE)  
	e2:SetCountLimit(2,m)  
	e2:SetCost(cm.cost)  
	e2:SetTarget(cm.target2)  
	e2:SetOperation(cm.operation2)  
	c:RegisterEffect(e2)  
	--damage
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,2)) 
	e3:SetCategory(CATEGORY_DAMAGE)   
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND+LOCATION_MZONE)  
	e3:SetCountLimit(2,m)  
	e3:SetCost(cm.cost)  
	e3:SetTarget(cm.target3)  
	e3:SetOperation(cm.operation3)  
	c:RegisterEffect(e3)  
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() or c:IsAbleToRemoveAsCost() end 
	if c:IsAbleToGraveAsCost() and c:IsAbleToRemoveAsCost() then
		local op=Duel.SelectOption(tp,1103,1005)
		if op==0 then
			Duel.SendtoGrave(c,REASON_COST)
		else
			if op==1 then
				Duel.Remove(c,POS_FACEUP,REASON_COST)
			end
		end
	else
		if c:IsAbleToGraveAsCost() then
			Duel.SendtoGrave(c,REASON_COST)  
		else
			if c:IsAbleToRemoveAsCost() then
				Duel.Remove(c,POS_FACEUP,REASON_COST)
			end
		end
	end
end  
function cm.filter(c)  
	return c:IsCode(m) and c:IsAbleToHand()  
end  
function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)  
end  
function cm.operation1(e,tp,eg,ep,ev,re,r,rp,chk)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,g)  
	end  
end  
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,0,LOCATION_SZONE,1,nil) end  
end  
function cm.operation2(e,tp,eg,ep,ev,re,r,rp,chk)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)  
	local g=Duel.SelectMatchingCard(tp,Card.IsFacedown,tp,0,LOCATION_SZONE,1,1,nil)
	local tc=g:GetFirst()
	if tc then  
		Duel.HintSelection(g)
		local e1=Effect.CreateEffect(e:GetHandler())  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_CANNOT_TRIGGER)  
		e1:SetValue(1)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)  
		tc:RegisterEffect(e1)  
	end  
end 
function cm.target3(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.SetTargetPlayer(1-tp)  
	Duel.SetTargetParam(500)  
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)  
end  
function cm.operation3(e,tp,eg,ep,ev,re,r,rp)  
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)  
	Duel.Damage(p,d,REASON_EFFECT)  
end   