--绝地激斗的恋慕屋敷
function c9911075.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9911075+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9911075.target)
	e1:SetOperation(c9911075.operation)
	c:RegisterEffect(e1)
end
function c9911075.filter(c)
	return c:IsSetCard(0x8e) and c:IsAbleToHand()
end
function c9911075.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9911075.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9911075.cfilter2(c)
	return c:IsRace(RACE_ZOMBIE) and c:IsLocation(LOCATION_GRAVE)
end
function c9911075.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9911075.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
		local b1=Duel.CheckRemoveOverlayCard(tp,1,0,2,REASON_EFFECT)
		local b2=Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil,REASON_EFFECT)
		if b1 and (not b2 or Duel.SelectOption(tp,aux.Stringid(9911075,0),aux.Stringid(9911075,1))==0) then
			Duel.BreakEffect()
			Duel.RemoveOverlayCard(tp,1,0,2,2,REASON_EFFECT)
		elseif b2 then
			Duel.BreakEffect()
			Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
		else return end
		if Duel.GetOperatedGroup():IsExists(c9911075.cfilter2,1,nil)
			and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(9911075,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,1,nil)
			Duel.HintSelection(sg)
			Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
		end
	end
end
