local m=82209011
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_REMOVE)  
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)   
	e1:SetCountLimit(1,m)  
	e1:SetCondition(cm.con)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)  
	e1:SetOperation(cm.operation)  
	c:RegisterEffect(e1)  
end  
function cm.filter(c,sp)  
	return c:GetSummonPlayer()==sp  
end  
function cm.con(e,tp,eg,ep,ev,re,r,rp)  
	return eg:IsExists(cm.filter,1,nil,1-tp)  
end  
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()  
	if chk==0 then return c:IsDiscardable() end  
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)  
end  
function cm.thfilter(c,e,tp)  
	return c:IsType(TYPE_MONSTER) and not c:IsPublic() and Duel.IsExistingMatchingCard(cm.thfilter2,tp,LOCATION_DECK,0,1,nil,c,e,tp)
end  
function cm.thfilter2(c,rc,e,tp)  
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:IsRace(rc:GetRace()) and c:IsAttribute(rc:GetAttribute()) and Duel.IsExistingMatchingCard(cm.thfilter3,tp,LOCATION_HAND,0,1,c,rc) 
end  
function cm.thfilter3(c,rc)  
	return c:IsAbleToRemove() and c~=rc
end 
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_HAND,0,1,c,e,tp) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK) 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND)   
end  
function cm.operation(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()   
	local tc=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()
	if not tc then return end
	Duel.ConfirmCards(1-tp,tc)
	local tc2=Duel.SelectMatchingCard(tp,cm.thfilter2,tp,LOCATION_DECK,0,1,1,nil,tc,e,tp):GetFirst()
	if not tc2 then return end
	if Duel.SendtoHand(tc2,tp,REASON_EFFECT)==1 then
		Duel.ConfirmCards(1-tp,tc2)
		Duel.ShuffleHand(tp)
		local tc3=Duel.SelectMatchingCard(tp,cm.thfilter3,tp,LOCATION_HAND,0,1,1,tc,tc2)
		if tc3 then
			Duel.BreakEffect()
			Duel.Remove(tc3,POS_FACEDOWN,REASON_EFFECT)
		end
	end
end


