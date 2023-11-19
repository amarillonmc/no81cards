--静水流涌之辉
function c60002421.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetOperation(c60002421.operation)
	c:RegisterEffect(e1) 
	--immuse 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH) 
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetRange(LOCATION_SZONE)  
	e2:SetCountLimit(1) 
	e2:SetCondition(c60002421.imcon) 
	e2:SetTarget(c60002421.imtg) 
	e2:SetOperation(c60002421.imop) 
	c:RegisterEffect(e2)   
	--set
	local e4=Effect.CreateEffect(c) 
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e4:SetCode(EVENT_REMOVE) 
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE) 
	e4:SetRange(LOCATION_HAND)
	e4:SetCondition(c60002421.setcon) 
	e4:SetOperation(c60002421.setop) 
	c:RegisterEffect(e4) 
end
function c60002421.operation(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_SZONE) 
	e1:SetCost(c60002421.rmcost)
	e1:SetTarget(c60002421.rmtg) 
	e1:SetOperation(c60002421.rmop) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1) 
end 
function c60002421.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,nil) end 
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,1,nil) 
	Duel.Remove(g,POS_FACEUP,REASON_COST) 
end 
function c60002421.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local tc=Duel.GetDecktopGroup(tp,1):GetFirst()
	if chk==0 then return tc and tc:IsAbleToRemove() end 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,tc,1,tp,LOCATION_DECK)
end  
function c60002421.rmop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetDecktopGroup(tp,1):GetFirst() 
	if tc then 
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT) 
	end 
end 
function c60002421.pbfil(c,e,tp) 
	return not c:IsPublic() and c:IsAttribute(ATTRIBUTE_WATER) and Duel.IsExistingMatchingCard(c60002421.thfil,tp,LOCATION_DECK,0,1,nil,c:GetCode())  
end 
function c60002421.imcon(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.GetFieldGroupCount(tp,LOCATION_REMOVED,0)>0 and Duel.GetMatchingGroupCount(Card.IsFaceup,tp,LOCATION_REMOVED,0,nil)==Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_REMOVED,0,nil) 
end  
function c60002421.imtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return true end  
end 
function c60002421.imop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD) 
	e1:SetCode(EFFECT_IMMUNE_EFFECT) 
	e1:SetTargetRange(LOCATION_MZONE,0) 
	e1:SetTarget(function(e,c) 
	return c:IsSetCard(0x6ac) end)  
	e1:SetValue(function(e,te) 
	return e:GetOwnerPlayer()~=te:GetOwnerPlayer() and te:IsActivated() end)
	e1:SetReset(RESET_PHASE+PHASE_END) 
	Duel.RegisterEffect(e1,tp) 
end 
function c60002421.stfil(c,tp) 
	return c:GetReasonPlayer()==tp and c:IsFaceup() 
end 
function c60002421.setcon(e,tp,eg,ep,ev,re,r,rp) 
	return eg:IsExists(c60002421.stfil,1,nil,tp) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and Duel.GetTurnPlayer()==1-tp 
end 
function c60002421.setop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if c60002421.setcon(e,tp,eg,ep,ev,re,r,rp) then  
		if Duel.SelectEffectYesNo(tp,c,aux.Stringid(60002421,0)) then  
			Duel.Hint(HINT_CARD,0,60002421) 
			Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			c60002421.imop(e,tp,eg,ep,ev,re,r,rp)  
		end 
	end 
end 

