--至天际
function c77032564.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,77032564)
	e1:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk) 
	local flag=Duel.GetFlagEffectLabel(tp,77032561) 
	if chk==0 then return true end 
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(77032564,0))
	Duel.Hint(HINT_MESSAGE,1,aux.Stringid(77032564,0))
	if flag==nil then 
		Duel.RegisterFlagEffect(tp,77032561,RESET_PHASE+PHASE_END,0,1,1) 
	else  
		Duel.SetFlagEffectLabel(tp,77032561,flag+1)  
	end end)  
	e1:SetTarget(c77032564.actg) 
	e1:SetOperation(c77032564.acop) 
	c:RegisterEffect(e1) 
	--atk 
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,17032564)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEDOWN) end) 
	e2:SetTarget(c77032564.atktg)
	e2:SetOperation(c77032564.atkop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e3)
end 
function c77032564.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(function(c) return c:IsCode(77032561) and c:IsAbleToHand() end,tp,LOCATION_DECK,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)  
end 
function c77032564.acop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(function(c) return c:IsCode(77032561) and c:IsAbleToHand() end,tp,LOCATION_DECK,0,nil) 
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,1,nil) 
		Duel.SendtoHand(sg,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)   
		if c:IsRelateToEffect(e) then 
			Duel.BreakEffect()  
			c:CancelToGrave()
			Duel.ChangePosition(c,POS_FACEDOWN)
			Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0) 
		end  
	end 
end 
function c77032564.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end  
end 
function c77032564.atkop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)  
	if g:GetCount()>0 then  
		local tc=g:GetFirst() 
		while tc do
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_UPDATE_ATTACK) 
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetRange(LOCATION_MZONE)  
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)   
		tc=g:GetNext() 
		end 
		if Duel.GetFlagEffect(tp,77032561)~=0 and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 and c:IsRelateToEffect(e) then 
			Duel.BreakEffect()
			c:CancelToGrave() 
			Duel.MoveToField(c,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
			Duel.ChangePosition(c,POS_FACEDOWN)
			Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0) 
		end   
	end 
end 


