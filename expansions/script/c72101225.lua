--深空 速攻
function c72101225.initial_effect(c)
	--draw2
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,72101225)
	e1:SetCondition(c72101225.dcon)
	e1:SetTarget(c72101225.dtg)
	e1:SetOperation(c72101225.dop)
	c:RegisterEffect(e1)
	
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,72101225)
	e2:SetCondition(c72101225.tdcon)
	e2:SetTarget(c72101225.tdtg)
	e2:SetOperation(c72101225.tdop)
	c:RegisterEffect(e2)

end

--draw2
function c72101225.dcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(nil,tp,LOCATION_MZONE,0,1,nil)
end
function c72101225.dfilter(c,e,tp)
	return c:IsSetCard(0xcea) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c72101225.dtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanSendtoDeck(tp) and Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c72101225.dop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	Duel.ShuffleHand(p)
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(p,c72101225.dfilter,p,LOCATION_HAND,0,1,1,nil)
	local tg=g:GetFirst()
	if tg then
		if Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)==0 then
			Duel.ConfirmCards(1-p,tg)
			Duel.ShuffleHand(p)
		end
	else
		local sg=Duel.GetFieldGroup(p,LOCATION_HAND,0)
		Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
	end
end

--to deck
function c72101225.tdconfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xcea)
end
function c72101225.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	return ct>0 and ct==Duel.GetMatchingGroupCount(c72101225.tdconfilter,tp,LOCATION_MZONE,0,nil)
end
function c72101225.czfilter(c)
	return c:IsCode(72101215) and (c:IsLocation(LOCATION_ONFIELD) and c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c72101225.tdfilter(c)
	return c:IsSetCard(0xcea) and (c:IsLocation(LOCATION_REMOVED) or c:IsLocation(LOCATION_GRAVE)) and c:IsAbleToDeck() and not c:IsCode(72101225)
end
function c72101225.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return (chkc:IsLocation(LOCATION_GRAVE) 
		or chkc:IsLocation(LOCATION_REMOVED))
		and chkc:IsSetCard(0xcea)
		and chkc:IsAbleToDeck() 
	end
	if chk==0 then return Duel.IsExistingTarget(c72101225.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,e:GetHandler()) end
	local ct=5
	if not Duel.IsExistingMatchingCard(c72101225.czfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil) then ct=3 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c72101225.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c72101225.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(aux.NecroValleyFilter(Card.IsRelateToEffect),nil,e)
	if tg:GetCount()>0 then
		Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		local th=Duel.GetOperatedGroup()
		local hc=th:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
		if th:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
		if hc==5 and Duel.IsPlayerCanDraw(tp,2) then
			Duel.BreakEffect()
			Duel.Draw(tp,2,REASON_EFFECT)
		end
	end
end
