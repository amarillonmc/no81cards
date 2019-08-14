--神魔邂逅
function c60150819.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,60150819+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c60150819.target)
	e1:SetOperation(c60150819.activate)
	c:RegisterEffect(e1)
end
function c60150819.filter(c)
	return c:IsSetCard(0x3b23) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c60150819.filter2(c)
	return c:IsSetCard(0x3b23) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c60150819.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetControler()==tp and chkc:GetLocation()==LOCATION_GRAVE and c60150819.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c60150819.filter,tp,LOCATION_GRAVE,0,1,nil) 
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_DECK,LOCATION_DECK,1,nil) 
		and Duel.IsExistingMatchingCard(c60150819.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c60150819.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	
end
function c60150819.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c60150819.filter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		local tc=Duel.GetFieldCard(tp,LOCATION_DECK,0)
		if tc:IsAbleToRemove() and Duel.SelectYesNo(tp,aux.Stringid(60150810,0)) then
			Duel.BreakEffect()
			Duel.DisableShuffleCheck()
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
	end
end