function c82224003.initial_effect(c)  
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetHintTiming(TIMINGS_CHECK_MONSTER)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetTarget(c82224003.target)  
	e1:SetOperation(c82224003.activate)  
	c:RegisterEffect(e1)  
end  
function c82224003.filter(c)  
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()  
end 
function c82224003.filter2(c)  
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand()  
end 
function c82224003.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()  
	if chk==0 then return Duel.IsExistingMatchingCard(c82224003.filter,tp,0,LOCATION_MZONE,1,c) end  
	local sg=Duel.GetMatchingGroup(c82224003.filter,tp,0,LOCATION_MZONE,c)  
	Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,sg:GetCount(),0,0)  
end
function c82224003.filter3(c)  
	return c:IsLocation(LOCATION_DECK) or c:IsLocation(LOCATION_EXTRA) or c:IsLocation(LOCATION_HAND)
end  
function c82224003.activate(e,tp,eg,ep,ev,re,r,rp)  
	local sg=Duel.GetMatchingGroup(c82224003.filter,tp,0,LOCATION_MZONE,e:GetHandler())  
	Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)  
	local tc=Duel.GetOperatedGroup()
	if tc:FilterCount(c82224003.filter3,nil)>0 then
		local sel=1
		Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(82224003,0)) 
		sel=Duel.SelectOption(1-tp,1213,1214)
		if sel==0 then
			Duel.ShuffleDeck(1-tp)
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)  
			local g=Duel.SelectMatchingCard(1-tp,c82224003.filter2,1-tp,LOCATION_DECK,0,1,tc:FilterCount(c82224003.filter3,nil),nil)
			if g:GetCount()>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)  
				Duel.ConfirmCards(1-tp,g)  
			end
		end
	end  
end  