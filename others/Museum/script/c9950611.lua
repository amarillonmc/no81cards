--fate·迪昂
function c9950611.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c9950611.target)
	e1:SetOperation(c9950611.activate)
	c:RegisterEffect(e1)
end
function c9950611.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,5)
		and Duel.GetDecktopGroup(tp,5):FilterCount(Card.IsAbleToHand,nil)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c9950611.filter(c)
	return c:IsSetCard(0xba5) and c:IsAbleToHand()
end
function c9950611.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerCanDiscardDeck(tp,5) then
		Duel.ConfirmDecktop(tp,5)
		local g=Duel.GetDecktopGroup(tp,5)
		if g:GetCount()>0 then
			if g:IsExists(c9950611.filter,1,nil) then
				Duel.DisableShuffleCheck()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sg=g:FilterSelect(tp,c9950611.filter,1,1,nil)
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
				Duel.ShuffleHand(tp)
				g:Sub(sg)
				Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
			else
				Duel.ShuffleDeck(tp)
			end
		end
	end
	if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c9950611.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9950611.splimit(e,c)
	return not c:IsSetCard(0xba5) and c:IsLocation(LOCATION_EXTRA)
end
