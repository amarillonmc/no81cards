--龙呼百应
function c10150068.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c10150068.condition)
	e1:SetCountLimit(1,10150068+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c10150068.cost)
	e1:SetTarget(c10150068.target)
	e1:SetOperation(c10150068.activate)
	c:RegisterEffect(e1)	
end
function c10150068.cfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsFaceup() and (c:IsLevelBelow(7) or c:IsRankAbove(7))
end
function c10150068.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10150068.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c10150068.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c10150068.ahfilter(c)
	return c:IsLevelBelow(4) and c:IsRace(RACE_DRAGON) and c:IsAbleToHand()
end
function c10150068.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10150068.ahfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10150068.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10150068.ahfilter,tp,LOCATION_DECK,0,1,2,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
