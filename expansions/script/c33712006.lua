local m=33712006
local cm=_G["c"..m]
cm.name="黄昏道"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>=2 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,nil,1-tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local op_deck=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
	if #op_deck<2 then return end
	local t={}
	local i=2
	local max=op_deck:GetCount()
	for i=2,max do t[i-1]=i end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_NUMBER)
	local num=Duel.AnnounceNumber(1-tp,table.unpack(t))
	Duel.ConfirmDecktop(1-tp,num)
	local g=Duel.GetDecktopGroup(1-tp,num)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
	local tc=g:Select(1-tp,1,1,nil):GetFirst()
	if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(tp,tc)
		g:RemoveCard(tc)
		Duel.DisableShuffleCheck()
		local tg_num=Duel.SendtoDeck(g,tp,SEQ_DECKTOP,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
		Duel.DiscardDeck(tp,tg_num,REASON_EFFECT)
	end
end