--共赴明日
function c29039321.initial_effect(c)
	aux.AddCodeList(c,29065500)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,29039321+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c29039321.target)
	e1:SetOperation(c29039321.activate)
	c:RegisterEffect(e1)
end
function c29039321.filter(c)
	return (c:IsCode(29065500) or aux.IsCodeListed(c,29065500)) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c29039321.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29039321.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c29039321.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c29039321.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end