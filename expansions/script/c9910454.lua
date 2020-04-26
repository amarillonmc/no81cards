--积聚希望的韶光
function c9910454.initial_effect(c)
	c:EnableCounterPermit(0x950)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,9910454)
	e2:SetCondition(c9910454.drcon)
	e2:SetTarget(c9910454.drtg)
	e2:SetOperation(c9910454.drop)
	c:RegisterEffect(e2)
end
function c9910454.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>2
end
function c9910454.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetCounter(tp,1,0,0x950)+3-Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	if chk==0 then return (ct<=0 or Duel.IsPlayerCanDraw(tp,ct))
		and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c9910454.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	if Duel.SendtoDeck(g,nil,0,REASON_EFFECT)~=0 then
		local og=g:Filter(Card.IsLocation,nil,LOCATION_DECK)
		if og:IsExists(Card.IsControler,1,nil,tp) then Duel.ShuffleDeck(tp) end
		if og:IsExists(Card.IsControler,1,nil,1-tp) then Duel.ShuffleDeck(1-tp) end
		Duel.BreakEffect()
		local ct=Duel.GetCounter(tp,1,0,0x950)+3
		Duel.Draw(tp,ct,REASON_EFFECT)
		local sg=Duel.GetOperatedGroup()
		Duel.ConfirmCards(1-tp,sg)
		if sg:GetClassCount(Card.GetCode)==sg:GetCount() then
			if sg:IsExists(Card.IsSetCard,1,nil,0x9950) then
				e:GetHandler():AddCounter(0x950,1)
				Duel.ShuffleHand(tp)
			end
		else
			Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
		end
	end
end
