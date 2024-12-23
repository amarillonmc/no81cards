--愚蠢的尽葬
function c22348444.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,22348444+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c22348444.target)
	e1:SetOperation(c22348444.activate)
	c:RegisterEffect(e1)
end
function c22348444.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_HAND,0,e:GetHandler())
	local ct=#g>=2 and #g*2+1 or #g*2
	if chk==0 then
		return #g>0 and Duel.IsPlayerCanDiscardDeck(tp,ct) and (#g<2 or Duel.IsPlayerCanDraw(tp,1))
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,#g,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,ct)
	if #g>=2 then
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
end
function c22348444.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	if Duel.SendtoGrave(g,REASON_EFFECT)>0 then
		local og=Duel.GetOperatedGroup()
		local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)
		if ct==0 then return end
		if not Duel.IsPlayerCanDiscardDeck(tp,ct*2) then return end
		Duel.BreakEffect()
		Duel.DiscardDeck(tp,ct*2,REASON_EFFECT)
		if ct==1 then return end
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
