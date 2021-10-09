--氮素宝牌
function c9950470.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_DECKDES+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c9950470.cost)
	e1:SetTarget(c9950470.target)
	e1:SetOperation(c9950470.activate)
	c:RegisterEffect(e1)
end
function c9950470.costfilter(c)
	return c:IsSetCard(0x1017) and c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c9950470.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9950470.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c9950470.costfilter,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c9950470.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,4) and Duel.IsPlayerCanDiscardDeck(tp,4)
		and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=6 end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(4)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,4)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,2)
end
function c9950470.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)==4 then
	Duel.BreakEffect()
	Duel.DiscardHand(p,nil,2,2,REASON_EFFECT+REASON_DISCARD)
	Duel.BreakEffect()
	Duel.DiscardDeck(tp,2,REASON_EFFECT)
	end
end

