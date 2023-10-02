--吾等之臂开拓一切 至天际
function c77032565.initial_effect(c) 
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,77032565)
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
	e1:SetTarget(c77032565.actg) 
	e1:SetOperation(c77032565.acop) 
	c:RegisterEffect(e1)
	--to hand 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE) 
	e2:SetCountLimit(1,17032565)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEDOWN) end) 
	e2:SetTarget(c77032565.thtg)
	e2:SetOperation(c77032565.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e3)
end 
function c77032565.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(function(c) return c:IsFaceup() and c:IsCode(77032561) end,tp,LOCATION_MZONE,0,1,nil) end  
	local g=Duel.SelectTarget(tp,function(c) return c:IsFaceup() and c:IsCode(77032561) end,tp,LOCATION_MZONE,0,1,1,nil)   
end  
function c77032565.acop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) then 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_IMMUNE_EFFECT) 
		e1:SetRange(LOCATION_MZONE)  
		e1:SetValue(function(e,te) 
		return e:GetOwnerPlayer()~=te:GetOwnerPlayer() end)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END) 
		tc:RegisterEffect(e1) 
		local flag=Duel.GetFlagEffectLabel(tp,77032561)  
		if flag and flag>0 then 
			Duel.BreakEffect() 
			local e1=Effect.CreateEffect(c) 
			e1:SetType(EFFECT_TYPE_SINGLE) 
			e1:SetCode(EFFECT_UPDATE_ATTACK) 
			e1:SetRange(LOCATION_MZONE)  
			e1:SetValue(flag*1000) 
			e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
			tc:RegisterEffect(e1) 
		end 
	end 
end 
function c77032565.thfil(c) 
	return c:IsAbleToHand() and c:IsCode(77032561)   
end 
function c77032565.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77032565.thfil,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end 
function c77032565.thop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c77032565.thfil,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,nil) 
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