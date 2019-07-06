--加帕里巴士
function c33700057.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33700057,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c33700057.tg)
	e1:SetOperation(c33700057.op)
	c:RegisterEffect(e1)	
end
function c33700057.cffilter(c)
	return c:IsSetCard(0x442) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck() and not c:IsPublic() and Duel.IsExistingMatchingCard(c33700057.hdfilter,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function c33700057.hdfilter(c,code)
	return c:IsSetCard(0x442) and not c:IsCode(code) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c33700057.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
	return Duel.IsExistingMatchingCard(c33700057.cffilter,tp,LOCATION_HAND,0,1,nil) end
Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c33700057.op(e,tp,eg,ep,ev,re,r,rp)
	 if  not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c33700057.cffilter,tp,LOCATION_HAND,0,1,1,nil)
	 Duel.ConfirmCards(1-tp,g)
	if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)>0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c33700057.hdfilter,tp,LOCATION_DECK,0,1,1,nil,g:GetFirst():GetCode())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
end