--胜利的法则决定了！
function c9981137.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c9981137.cost)
	e1:SetTarget(c9981137.rmtg)
	e1:SetOperation(c9981137.rmop)
	c:RegisterEffect(e1)
end
function c9981137.costfilter(c)
	return c:IsSetCard(0x5bc3) and c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c9981137.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9981137.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c9981137.costfilter,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c9981137.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_ONFIELD) and chkc:IsControler(1-tp) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE+LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE+LOCATION_ONFIELD,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),1-tp,LOCATION_GRAVE+LOCATION_ONFIELD)
end
function c9981137.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()~=0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end