--灵刀术式 刃锋再起
function c60001043.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60001043,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c60001043.target)
	e1:SetOperation(c60001043.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60001043,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,60001043)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c60001043.settg)
	e2:SetOperation(c60001043.setop)
	c:RegisterEffect(e2)
end
function c60001043.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,7)
		and Duel.GetDecktopGroup(tp,7):FilterCount(Card.IsAbleToHand,nil)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c60001043.filter(c)
	return c:IsSetCard(0x624) and c:IsAbleToHand()
end
function c60001043.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerCanDiscardDeck(tp,7) then
		Duel.ConfirmDecktop(tp,7)
		local g=Duel.GetDecktopGroup(tp,7)
		if g:GetCount()>0 then
			if g:IsExists(c60001043.filter,1,nil) then
				Duel.DisableShuffleCheck()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sg=g:FilterSelect(tp,c60001043.filter,1,1,nil)
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
end
function c60001043.stfilter(c)
	return c:IsSetCard(0x624) and c:IsType(TYPE_SPELL) and c:IsSSetable()
end
function c60001043.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c60001043.stfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil) end
end
function c60001043.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c60001043.stfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil)
	if #g>0 then
		Duel.SSet(tp,g)
	end
end

