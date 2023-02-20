--冰帝近卫兵
function c98920191.initial_effect(c)
	--todeck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920191,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,98920191)
	e1:SetTarget(c98920191.target)
	e1:SetOperation(c98920191.operation)
	c:RegisterEffect(e1)
end
function c98920191.filter(c)
	return c:IsDefense(1000) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c98920191.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c98920191.filter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingTarget(c98920191.filter,tp,LOCATION_GRAVE,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c98920191.filter,tp,LOCATION_GRAVE,0,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,3,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c98920191.operation(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=3 then return end
	Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	local at=g:FilterCount(Card.IsAttack,nil,800)
	local bt=g:FilterCount(Card.IsAttack,nil,2400)
	local dt=g:FilterCount(Card.IsAttack,nil,2800)
	local g2=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
	if ct==3 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
		if at>0 then
		   if Duel.GetFlagEffect(tp,98920191)~=0 then return end
		   local e1=Effect.CreateEffect(e:GetHandler())
		   e1:SetDescription(aux.Stringid(98920191,2))
		   e1:SetType(EFFECT_TYPE_FIELD)
		   e1:SetTargetRange(LOCATION_HAND,0)
		   e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
		   e1:SetValue(0x1)
		   e1:SetReset(RESET_PHASE+PHASE_END)
		   Duel.RegisterEffect(e1,tp)
		   local e2=e1:Clone()
		   e2:SetCode(EFFECT_EXTRA_SET_COUNT)
		   Duel.RegisterEffect(e2,tp)
		   Duel.RegisterFlagEffect(tp,98920191,RESET_PHASE+PHASE_END,0,1)
	   end
	   if bt>0 and Duel.IsExistingMatchingCard(c98920191.thfilter,tp,LOCATION_DECK,0,1,nil) then
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		  local sg=Duel.SelectMatchingCard(tp,c98920191.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		  if sg:GetCount()>0 then
			 Duel.SendtoHand(sg,nil,REASON_EFFECT)
			 Duel.ConfirmCards(1-tp,sg)
		  end
	   end
	   if dt>0 and #g2>0 then	   
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local t2=g2:Select(tp,1,1,nil)
			Duel.HintSelection(t2)
			Duel.Destroy(t2,REASON_EFFECT)
		end
	end
end
function c98920191.thfilter(c)
	return c:IsSetCard(0xbe) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end