--元素飞球之雨
local m=13254038
local cm=_G["c"..m]
xpcall(function() require("expansions/script/tama") end,function() require("script/tama") end)
function cm.initial_effect(c)
	--discard deck
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DECKDES,CATEGORY_DRAW)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(cm.distg)
	e1:SetOperation(cm.disop)
	c:RegisterEffect(e1)
	
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,3) end
end
function cm.filter(c)
	return c:IsSetCard(0x356) and c:IsType(TYPE_MONSTER)
end
function cm.filter1(c)
	return c:IsSetCard(0x356) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function cm.filter2(c)
	return c:IsSetCard(0x356) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(tp,3) then return end
	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3)
	local sg=g:Filter(cm.filter,nil)
	if sg:GetCount()<=0 then return end
	Duel.DisableShuffleCheck()
	Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
	local sg1=Duel.GetOperatedGroup()
	local sg2=sg1:Clone()
	if sg1:GetCount()>0 then
		if sg1:GetSum(tama.tamas_getElements,13254033)>0 and Duel.IsPlayerCanDiscardDeck(tp,2) then
			Duel.BreakEffect()
			Duel.ShuffleDeck(tp)
			Duel.DiscardDeck(tp,2,REASON_EFFECT)
			sg2:Merge(Duel.GetOperatedGroup())
		end
		if sg1:GetSum(tama.tamas_getElements,13254031)>0 and Duel.IsPlayerCanDraw(tp,1) then
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
			Duel.ShuffleHand(tp)
			Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD)
			sg2:Merge(Duel.GetOperatedGroup())
		end
		if sg1:GetSum(tama.tamas_getElements,13254036)>0 and sg2:IsExists(cm.filter2,1,nil) then
			local sg3=sg2:Filter(cm.filter2,nil)
			local ct=sg3:GetCount()
			Duel.BreakEffect()
			Duel.SendtoDeck(sg3,tp,2,REASON_EFFECT)
			Duel.ShuffleDeck(tp)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg4=Duel.SelectMatchingCard(tp,cm.filter1,tp,LOCATION_DECK,0,ct,ct,nil)
			Duel.SendtoGrave(sg4,REASON_EFFECT)
		end
	end

end
