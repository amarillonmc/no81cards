--未知的埋葬
local m=11451703
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.tdtg)
	e1:SetOperation(cm.tdop)
	c:RegisterEffect(e1)
end
function cm.tdfilter(c)
	return c:IsAbleToDeck() and not c:IsPublic()
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tdfilter,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(nil,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(nil,tp,LOCATION_EXTRA,0,1,nil) end
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(cm.tdfilter,tp,LOCATION_HAND,0,nil)
	local g2=Duel.GetMatchingGroup(nil,tp,LOCATION_DECK,0,nil)
	local g3=Duel.GetMatchingGroup(nil,tp,LOCATION_EXTRA,0,nil)
	if #g1>0 and #g2>0 and #g3>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg=g1:Select(tp,1,1,nil)
		local sg2=g2:Select(tp,1,1,nil)
		local sg3=g3:Select(tp,1,1,nil)
		sg:Merge(sg2)
		sg:Merge(sg3)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleDeck(tp)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TODECK)
		local tc=sg:RandomSelect(1-tp,1):GetFirst()
		sg:RemoveCard(tc)
		if tc:IsLocation(LOCATION_HAND) then Duel.SendtoDeck(tc,nil,2,REASON_EFFECT) end
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end