--千星行为
function c11561021.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCondition(function(e) 
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and not Duel.CheckPhaseActivity() end)
	e1:SetTarget(c11561021.actg) 
	e1:SetOperation(c11561021.acop) 
	c:RegisterEffect(e1) 
end
function c11561021.actg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,0,1,nil) and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,1,nil) end  
end 
function c11561021.acop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local g1=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,0,nil) 
	local g2=Duel.GetMatchingGroup(nil,tp,0,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,nil) 
	if g1:GetClassCount(Card.GetLocation)>=3 and g2:GetClassCount(Card.GetLocation)>=3 then  
		Duel.ConfirmCards(tp,g2) 
		Duel.ConfirmCards(1-tp,g1)   
		local tg1=g1:SelectSubGroup(1-tp,function(g) return g:GetClassCount(Card.GetLocation)==g:GetCount() end,false,3,3) 
		local tg2=g2:SelectSubGroup(tp,function(g) return g:GetClassCount(Card.GetLocation)==g:GetCount() end,false,3,3) 
		local tc1=tg1:GetFirst() 
		while tc1 do 
		if tc1:IsLocation(LOCATION_HAND) then 
			Duel.SendtoHand(tc1,1-tp,REASON_EFFECT) 
		elseif tc1:IsLocation(LOCATION_DECK+LOCATION_EXTRA) then  
			Duel.SendtoDeck(tc1,1-tp,2,REASON_EFFECT)  
		end 
		tc1=tg1:GetNext() 
		end 
		local tc2=tg2:GetFirst() 
		while tc2 do  
		if tc2:IsLocation(LOCATION_HAND) then 
			Duel.SendtoHand(tc2,tp,REASON_EFFECT) 
		elseif tc2:IsLocation(LOCATION_DECK+LOCATION_EXTRA) then  
			Duel.SendtoDeck(tc2,tp,2,REASON_EFFECT)  
		end 
		Duel.Exile(tc2,REASON_RULE) 
		local token=Duel.CreateToken(tp,tc2:GetOriginalCode()) 
		if tc2:IsPreviousLocation(LOCATION_HAND) then 
			Duel.SendtoHand(tc2,tp,REASON_EFFECT) 
		elseif tc2:IsPreviousLocation(LOCATION_DECK+LOCATION_EXTRA) then  
			Duel.SendtoDeck(tc2,tp,2,REASON_EFFECT)  
		end 
		tc2=tg2:GetNext() 
		end 
		Duel.ShuffleHand(tp) 
		Duel.ShuffleDeck(tp)
		Duel.ShuffleHand(1-tp) 
		Duel.ShuffleDeck(1-tp)
	end 
end 



