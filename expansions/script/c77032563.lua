--罗马！！
function c77032563.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,77032563)
	e1:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk) 
	local flag=Duel.GetFlagEffectLabel(tp,77032561) 
	if chk==0 then return true end 
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(77032563,0))
	Duel.Hint(HINT_MESSAGE,1,aux.Stringid(77032563,0))
	if flag==nil then 
		Duel.RegisterFlagEffect(tp,77032561,RESET_PHASE+PHASE_END,0,1,1) 
	else  
		Duel.SetFlagEffectLabel(tp,77032561,flag+1)  
	end end)  
	e1:SetTarget(c77032563.actg) 
	e1:SetOperation(c77032563.acop) 
	c:RegisterEffect(e1) 
	--to hand 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,17032563)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEDOWN) end) 
	e2:SetTarget(c77032563.thtg)
	e2:SetOperation(c77032563.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e3)
end 
function c77032563.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
end 
function c77032563.acop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) then 
		c:CancelToGrave()
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0) 
	end 
end 
function c77032563.thfil(c) 
	return c:IsAbleToHand() and c:IsCode(77032561,77032562)  
end 
function c77032563.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77032563.thfil,tp,LOCATION_DECK,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end 
function c77032563.thop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c77032563.thfil,tp,LOCATION_DECK,0,nil) 
	if g:GetCount()>0 then 
		local tc=g:Select(tp,1,1,nil):GetFirst() 
		Duel.SendtoHand(tc,tp,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,tc) 
		if Duel.GetFlagEffect(tp,77032561)~=0 and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 and c:IsRelateToEffect(e) then 
			Duel.BreakEffect()
			c:CancelToGrave() 
			Duel.MoveToField(c,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
			Duel.ChangePosition(c,POS_FACEDOWN)
			Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0) 
		end   
	end 
end 







