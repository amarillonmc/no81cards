--光道引导向の未来
function c60000008.initial_effect(c)
	 --discard deck
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_DECKDES)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTarget(c60000008.distarget)
	e1:SetOperation(c60000008.disop)
	c:RegisterEffect(e1)
end
function c60000008.distarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,0,0,PLAYER_ALL,5)
end
function c60000008.disop(e,tp,eg,ep,ev,re,r,rp)
	 Duel.DiscardDeck(tp,5,REASON_EFFECT)
	Duel.DiscardDeck(1-tp,5,REASON_EFFECT)
end