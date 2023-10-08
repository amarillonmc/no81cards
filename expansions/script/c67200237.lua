--白地龙骑士团的援护
function c67200237.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,67200237)
	e1:SetTarget(c67200237.target)
	e1:SetOperation(c67200237.activate)
	c:RegisterEffect(e1)	
end
function c67200237.filter(c)
	return c:IsLevelBelow(4) and c:IsRace(RACE_WARRIOR) and c:IsAbleToHand() and c:IsType(TYPE_PENDULUM)
end
function c67200237.filter1(c)
	return c:IsSetCard(0x3678) and not c:IsForbidden() and c:IsType(TYPE_PENDULUM)
end
function c67200237.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200237.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c67200237.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c67200237.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local tc1=g:GetFirst()
		if g:GetFirst():IsSetCard(0x3678) and not tc1:IsForbidden() and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>1 and Duel.IsExistingMatchingCard(c67200237.filter1,tp,LOCATION_DECK,0,1,nil) and Duel.CheckLocation(tp,LOCATION_PZONE,0) and Duel.CheckLocation(tp,LOCATION_PZONE,1) and Duel.SelectYesNo(tp,aux.Stringid(67200237,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
			local gg=Duel.SelectMatchingCard(tp,c67200237.filter1,tp,LOCATION_DECK,0,1,1,nil)
			local tc2=gg:GetFirst()
			if Duel.MoveToField(tc1,tp,tp,LOCATION_PZONE,POS_FACEUP,false) then
				if Duel.MoveToField(tc2,tp,tp,LOCATION_PZONE,POS_FACEUP,false) then
					tc2:SetStatus(STATUS_EFFECT_ENABLED,true)
				end
				tc1:SetStatus(STATUS_EFFECT_ENABLED,true)
			end
			Duel.BreakEffect()
			--
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local g1=Duel.GetFieldGroup(tp,LOCATION_HAND,0):Select(tp,1,1,nil)
			Duel.SendtoDeck(g1,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)		  
		end
	end
end
