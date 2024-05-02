--闪耀的新星
function c28323723.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_COUNTER+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c28323723.thcost)
	e1:SetTarget(c28323723.thtg)
	e1:SetOperation(c28323723.thop)
	c:RegisterEffect(e1)
end
function c28323723.cfilter(c)
	return c:IsSetCard(0x283) and not c:IsPublic() and c:IsAbleToDeck()
end
function c28323723.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function c28323723.thfilter(c)
	return c:IsSetCard(0x288,0x289,0x28a,0x28b) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c28323723.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c28323723.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) and Duel.IsExistingMatchingCard(c28323723.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,2,nil) end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c28323723.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c28323723.ctfilter(c)
	return c:IsCanAddCounter(0x1283,1) and c:IsFaceup()
end
function c28323723.sefilter(c)
	return c:IsSetCard(0x289) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c28323723.exfilter(c)
	return c:IsSetCard(0x28a) and c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c28323723.rmfilter(c)
	return c:IsSetCard(0x283) and c:IsAbleToRemove()
end
function c28323723.stfilter(c)
	return c:IsSetCard(0x288) and not c:IsPublic()
end
function c28323723.nofilter(c)
	return c:IsSetCard(0x289) and not c:IsPublic()
end
function c28323723.shfilter(c)
	return c:IsSetCard(0x28a) and not c:IsPublic()
end
function c28323723.cofilter(c)
	return c:IsSetCard(0x28b) and not c:IsPublic()
end
function c28323723.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c28323723.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,2,2,nil)
	if Duel.SendtoHand(tg,nil,REASON_EFFECT)==0 then return end
	Duel.ConfirmCards(1-tp,tg)
	if tc:IsRelateToEffect(e) then Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT) end
	local b1,b2,b3,b4=false
	if Duel.IsExistingMatchingCard(c28323723.stfilter,tp,LOCATION_HAND,0,2,nil) and Duel.IsExistingMatchingCard(c28323723.ctfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) then b1=true end
	if Duel.IsExistingMatchingCard(c28323723.nofilter,tp,LOCATION_HAND,0,2,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(c28323723.sefilter,tp,LOCATION_DECK,0,1,nil) then b2=true end
	if Duel.IsExistingMatchingCard(c28323723.shfilter,tp,LOCATION_HAND,0,2,nil) and Duel.IsExistingMatchingCard(c28323723.exfilter,tp,LOCATION_EXTRA,0,1,nil) then b3=true end
	if Duel.IsExistingMatchingCard(c28323723.cofilter,tp,LOCATION_HAND,0,2,nil) and Duel.IsExistingMatchingCard(c28323723.rmfilter,tp,LOCATION_GRAVE,0,1,nil) then b4=true end
	if not (b1 or b2 or b3 or b4) then return end
	local off=1
	local ops,opval={},{}
	if b1 then
		ops[off]=aux.Stringid(28323723,0)
		opval[off]=0
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(28323723,1)
		opval[off]=1
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(28323723,2)
		opval[off]=2
		off=off+1
	end
	if b4 then
		ops[off]=aux.Stringid(28323723,3)
		opval[off]=3
		off=off+1
	end
	if true then
		ops[off]=aux.Stringid(28323723,4)
		opval[off]=4
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))+1
	local sel=opval[op]
	if sel~=4 then Duel.BreakEffect() end
	if sel==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=Duel.SelectMatchingCard(tp,c28323723.stfilter,tp,LOCATION_HAND,0,2,2,nil)
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=Duel.SelectMatchingCard(tp,c28323723.ctfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c)
		if #g>0 then g:GetFirst():AddCounter(0x1283,1) end
	elseif sel==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=Duel.SelectMatchingCard(tp,c28323723.nofilter,tp,LOCATION_HAND,0,2,2,nil)
		Duel.BreakEffect()
		Duel.ShuffleHand(tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
		Duel.SendtoDeck(g1,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g2=Duel.SelectMatchingCard(tp,c28323723.sefilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoHand(g2,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g2)
	elseif sel==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=Duel.SelectMatchingCard(tp,c28323723.shfilter,tp,LOCATION_HAND,0,2,2,nil)
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c28323723.exfilter,tp,LOCATION_EXTRA,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	elseif sel==3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=Duel.SelectMatchingCard(tp,c28323723.cofilter,tp,LOCATION_HAND,0,2,2,nil)
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c28323723.rmfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
