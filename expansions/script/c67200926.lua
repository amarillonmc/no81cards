--逆潮之邂逅
function c67200926.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200926,0))
	e1:SetCategory(CATEGORY_TOEXTRA+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,67200926+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c67200926.target)
	e1:SetOperation(c67200926.operation)
	c:RegisterEffect(e1)   
end
c67200926.SetCard_Counter_current=true 
--
function c67200926.filter1(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x67a) and c:IsFaceupEx()
end
function c67200926.filter0(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xa67a) and c:IsFaceupEx()
end
function c67200926.filter2(c)
	return c:IsCode(67200924) and c:IsAbleToHand()
end
function c67200926.filter3(c)
	return c:IsSetCard(0x67a) and c:IsAbleToHand()
end
function c67200926.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.IsExistingMatchingCard(c67200926.filter1,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingMatchingCard(c67200926.filter2,tp,LOCATION_DECK,0,1,nil)) or (Duel.IsExistingMatchingCard(c67200926.filter0,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingMatchingCard(c67200926.filter3,tp,LOCATION_DECK,0,1,nil)) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c67200926.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(67200926,2))
	local g=Duel.SelectMatchingCard(tp,c67200926.filter1,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoExtraP(g,nil,REASON_EFFECT)~=0 then
		if g:GetFirst():IsSetCard(0xa67a) and Duel.IsExistingMatchingCard(c67200926.filter3,tp,LOCATION_DECK,0,1,nil) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,c67200926.filter3,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		else 
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,c67200926.filter2,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end
	end
end