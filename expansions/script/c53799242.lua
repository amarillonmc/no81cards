local m=53799242
local cm=_G["c"..m]
cm.name="梦想三角踢"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_DECKDES)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.distarget)
	e1:SetOperation(cm.disop)
	c:RegisterEffect(e1)
end
function cm.filter(c)
	return c:GetMutualLinkedGroupCount()>0 and c:IsLinkBelow(2)
end
function cm.distarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	if chk==0 then return #g>0 and Duel.IsPlayerCanDiscardDeck(tp,g:GetSum(Card.GetLink)) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,g:GetSum(Card.GetLink))
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	if #g>0 then Duel.DiscardDeck(tp,g:GetSum(Card.GetLink),REASON_EFFECT) end
end
