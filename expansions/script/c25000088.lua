local m=25000088
local cm=_G["c"..m]
cm.name="寒冬夜行人"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return Duel.GetTurnPlayer()~=e:GetHandlerPlayer()end)
	c:RegisterEffect(e2)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:CancelToGrave()
		if Duel.SendtoDeck(c,nil,2,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_DECK) then
			Duel.BreakEffect()
			Duel.ConfirmDecktop(tp,9)
			local g=Duel.GetDecktopGroup(tp,9)
			local ct=g:FilterCount(Card.IsCode,nil,m)
			Duel.ShuffleDeck(tp)
			if ct==1 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local thg=Duel.SelectMatchingCard(tp,function(c)return c:IsCode(m) and c:IsAbleToHand()end,tp,LOCATION_DECK,0,1,1,nil)
				if thg:GetCount()>0 then
					Duel.SendtoHand(thg,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,thg)
				end
			end
			if ct==2 and Duel.IsPlayerCanDraw(tp,3) then Duel.Draw(tp,3,REASON_EFFECT) end
			if ct==3 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_DECK,0,1,1,nil)
				if sg:GetCount()>0 then
					Duel.SendtoHand(sg,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,sg)
				end
			end
		end
	end
end
