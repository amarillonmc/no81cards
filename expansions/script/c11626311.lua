--隐匿虫的赠礼
function c11626311.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c11626311.target)
	e1:SetOperation(c11626311.operation)
	c:RegisterEffect(e1)	
end 
function c11626311.filter(c)
	return c:IsSetCard(0x3220) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck() and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c11626311.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c11626311.filter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2)
		and Duel.IsExistingTarget(c11626311.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,4,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c11626311.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,4,4,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,4,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c11626311.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=4 then return end
	if tg:GetCount()>0 then
		local tc=tg:GetFirst()
		while tc do
		if tc:IsType(TYPE_LINK) then
			Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
			tc=tg:GetNext()
		else
			Duel.SendtoDeck(tc,1-tp,1,REASON_EFFECT)
			Duel.ShuffleDeck(1-tp)
			tc:ReverseInDeck() 
			tc=tg:GetNext()
		end
		end
	local ct=tg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA+LOCATION_DECK)
	if ct>0 then
		Duel.BreakEffect()
		Duel.Draw(tp,2,REASON_EFFECT)
	end
	end
end