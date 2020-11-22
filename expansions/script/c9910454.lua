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
	e2:SetCost(c9910454.drcost)
	e2:SetTarget(c9910454.drtg)
	e2:SetOperation(c9910454.drop)
	c:RegisterEffect(e2)
end
function c9910454.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c9910454.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetCounter(tp,1,0,0x950)+1
	if chk==0 then return Duel.IsPlayerCanDraw(tp,ct) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c9910454.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local ct=Duel.GetCounter(tp,1,0,0x950)+1
	if Duel.Draw(tp,ct,REASON_EFFECT)==0 then return end
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	if g:GetCount()<1 then return end
	Duel.BreakEffect()
	Duel.ConfirmCards(1-tp,g)
	if g:GetClassCount(Card.GetCode)==g:GetCount() then
		if g:IsExists(Card.IsSetCard,1,nil,0x9950) then
			e:GetHandler():AddCounter(0x950,1)
			Duel.ShuffleHand(tp)
		end
	else
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
