--幽鬼流言
function c9910262.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9910262+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9910262.target)
	e1:SetOperation(c9910262.operation)
	c:RegisterEffect(e1)
end
function c9910262.filter(c,tp)
	local flag=true
	if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,9910262) then
		flag=not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,c:GetCode())
	else
		flag=c:IsCode(9910262)
	end
	return c:IsSetCard(0x953) and c:IsAbleToHand() and flag
end
function c9910262.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910262.filter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9910262.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9910262.filter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g)
		local tg=Duel.GetMatchingGroup(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,0,c,0x953,1)
		if tg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9910262,0)) then
			for tc in aux.Next(tg) do
				if tc:IsCanAddCounter(0x953,1) then
					tc:AddCounter(0x953,1)
				end
			end
		end
	end
end
