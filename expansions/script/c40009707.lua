--极光战姬出警
function c40009707.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,40009707+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c40009707.activate)
	c:RegisterEffect(e1)  
	--change effect type
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(40009707)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(1,0)
	c:RegisterEffect(e2) 
end
function c40009707.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xbf1b) and c:IsAbleToHand()
end
function c40009707.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c40009707.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(40009707,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end