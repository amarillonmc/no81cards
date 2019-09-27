--平成时代 FOREVER
function c9981185.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c9981185.cost)
	e1:SetTarget(c9981185.target)
	e1:SetOperation(c9981185.activate)
	c:RegisterEffect(e1)
end
function c9981185.costfilter(c)
	return c:IsSetCard(0xbca) and c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c9981185.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9981185.costfilter,tp,LOCATION_HAND,0,2,nil) end
	Duel.DiscardHand(tp,c9981185.costfilter,2,2,REASON_COST+REASON_DISCARD,nil)
end
function c9981185.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,3) and Duel.IsPlayerCanDiscardDeck(tp,3)
		and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=6 end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(3)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,3)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,3)
end
function c9981185.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	Duel.BreakEffect()
	Duel.DiscardDeck(tp,3,REASON_EFFECT)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981185,0))
end